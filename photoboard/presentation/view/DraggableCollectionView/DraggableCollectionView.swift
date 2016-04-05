//
//  DraggableCollectionView.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/06.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import UIKit

class DraggableCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    
    private var dummyCell: UIImageView?
    private var dummyCellCenter: CGPoint = CGPoint.zero
    var fromIndexPath: NSIndexPath?
    var toIndexPath: NSIndexPath?
    var hiddenIndexPath: NSIndexPath?
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    private var dragGestureRecognizer: UIPanGestureRecognizer!
    private var scaleRecognizer: UIPinchGestureRecognizer!
    private var scrollDirection = ScrollDirection.UNKNOWN
    private var timer: CADisplayLink? = nil
    private var fingerTranslation: CGPoint = CGPoint.zero
    var scrollEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(50, 50, 50, 50)
    var scrollSpeed: CGFloat = 400
    var currentScale: CGFloat = 1.0
    private var startedScale: CGFloat = 0
    private var startContentOffset: CGPoint = CGPoint()
    
    /// ドラッグ可能にするかどうか
    var draggable: Bool {
        get {
            return longPressGestureRecognizer.enabled
        }
        set {
            longPressGestureRecognizer.enabled = newValue
            dragGestureRecognizer.enabled = newValue
        }
    }
    
    /// 拡大縮小可能にするかどうか
    var zoomable: Bool {
        get {
            return scaleRecognizer.enabled
        }
        set {
            scaleRecognizer.enabled = newValue
        }
    }
    
    private enum ScrollDirection {
        case UNKNOWN
        case UP
        case DOWN
        case LEFT
        case RIGHT
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /**
     初期化
     */
    private func setup() {
        longPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self, action:#selector(DraggableCollectionView.updateLongPressGesture(_:)))
        longPressGestureRecognizer.delegate = self
        dragGestureRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(DraggableCollectionView.updatePanPressGesture(_:)))
        dragGestureRecognizer.delegate = self
        scaleRecognizer = UIPinchGestureRecognizer(
            target: self, action: #selector(DraggableCollectionView.updateScaleGesture(_:)))
        scaleRecognizer.delegate = self
        
        self.addGestureRecognizer(longPressGestureRecognizer)
        self.addGestureRecognizer(dragGestureRecognizer)
        self.addGestureRecognizer(scaleRecognizer)
        /*
        for gestureRecognizer in self.gestureRecognizers! {
            if gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer.self) {
                gestureRecognizer.requireGestureRecognizerToFail(longPressGestureRecognizer)
                break;
            }
        }*/
       
    }
    
    /**
     ドラッグ中に動かすセルを作成する（実際の選んだセルは消えていてドラッグ中はダミーセルを動かす）
     
     - parameter cell: ダミーセルを作るための、コピー元
     
     - returns: ダミーセル
     */
    private func createDummyCell(cell: UICollectionViewCell) -> UIImageView {
        let imageView = UIImageView(frame: cell.frame)
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.opaque, 0)
        cell.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = image
        
        imageView.layer.shadowOffset = CGSize(width: 8, height: 8)
        imageView.layer.shadowOpacity = 0.8
        
        return imageView
    }
    
    /**
     画面座標からセルのインデックスパスを取得する
        (移動先のインデックスパスを取得するため、存在しているセル以外にも、
        セクションの後尾＋１を見ている)
     
     - parameter point: 画面座標
     
     - returns: インデックスパス
     */
    private func indexPathAtPoint( point: CGPoint ) -> NSIndexPath? {
        let numSection = self.numberOfSections() ?? 0
        for section in 0..<numSection {
            var numCell = self.numberOfItemsInSection(section) ?? 0
            
            //セクションをまたぐとき他のセクションの後尾にドラッグできるようにする
            if fromIndexPath?.section != section {
                numCell += 1
            }
            
            for cell in 0..<numCell {
                let indexPath = NSIndexPath(forItem: cell, inSection: section)
                if let attribute = self.collectionViewLayout
                    .layoutAttributesForItemAtIndexPath(indexPath) {
                    let rect = CGRect(x: attribute.center.x - attribute.size.width/2,
                        y: attribute.center.y - attribute.size.height/2,
                        width: attribute.size.width,
                        height: attribute.size.height )
                    if CGRectContainsPoint( rect, point ) {
                        return indexPath
                    }
                }
            }
        }
        return nil
    }
    
    /**
     ジェスチャが認識するかを設定する
     
     - parameter gestureRecognizer: ジェスチャ
     
     - returns: trueなら動作、falseならば動かない
     */
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(self.dragGestureRecognizer) {
            return fromIndexPath != nil
        }
        return true
    }
    
    /**
     複数のジェスチャ動作時の競合を解消する
     
     - parameter gestureRecognizer:      ジェスチャ
     - parameter otherGestureRecognizer: もう一つのジェスチャ
     
     - returns: trueなら動作、falseならば動かない
     */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer
        otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(self.longPressGestureRecognizer) {
            return otherGestureRecognizer.isEqual(self.dragGestureRecognizer)
        }
        if gestureRecognizer.isEqual(self.dragGestureRecognizer) {
            return otherGestureRecognizer.isEqual(self.longPressGestureRecognizer)
        }
        return false
    }
 
    /**
     長押し時の動作
     
     - parameter recognizer: ジェスチャ
     */
    func updateLongPressGesture(recognizer: UILongPressGestureRecognizer) {
        
        switch recognizer.state {
        case .Began:
            guard let indexPath = self.indexPathForItemAtPoint(
                recognizer.locationInView(self)) else {
                return
            }
            guard let pressedCell = self.cellForItemAtIndexPath(indexPath) else {
                return
            }
            
            //ダミーセル作成
            pressedCell.highlighted = false
            dummyCell?.removeFromSuperview()
            dummyCell = createDummyCell(pressedCell)
            dummyCellCenter = (dummyCell?.center)!
            self.addSubview(dummyCell!)
            UIView.animateWithDuration(0.1, animations: {
                () -> Void in self.dummyCell!.transform = CGAffineTransformMakeScale(1.1, 1.1) })
            
            fromIndexPath = indexPath
            toIndexPath = indexPath
            hiddenIndexPath = indexPath
            self.collectionViewLayout.invalidateLayout()
            break
        case .Ended, .Cancelled:
            guard fromIndexPath != nil else {
                return
            }
            if let dataSource = self.dataSource as? DraggableCollectionDataSource {
                dataSource.collectionView!(self,
                    moveItemAtIndexPath: fromIndexPath!, toIndexPath:toIndexPath!)
            }
            
            self.performBatchUpdates({
                    () -> Void in
                    self.moveItemAtIndexPath(self.fromIndexPath!, toIndexPath: self.toIndexPath!)
                    self.fromIndexPath = nil
                    self.toIndexPath = nil
                print("performBatchUpdates")
                }, completion:nil)
            //ダミーセルが狙ったセルに移動する処理
            UIView.animateWithDuration(0.1, animations: {
                    () -> Void in
                    let fromAttribute = self
                        .layoutAttributesForItemAtIndexPath(self.hiddenIndexPath!)
                    self.dummyCell!.center = fromAttribute!.center
                    self.dummyCell!.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: {
                    (finished: Bool) -> Void in
                    self.dummyCell?.removeFromSuperview()
                    self.dummyCell = nil
                    self.hiddenIndexPath = nil
                    self.collectionViewLayout.invalidateLayout()
                    print("end animateWithDuration")
                    if let dataSource = self.dataSource as? DraggableCollectionDataSource {
                        dataSource.finishedMove(self)
                    }
                    self.collectionViewLayout.invalidateLayout()
                })
            self.invalidatesScrollTimer()
            break
        default:
            break
        }
    }
    
    /**
     ドラッグ時の動作
     
     - parameter recognizer: ジェスチャ
     */
    func updatePanPressGesture(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Changed {
            fingerTranslation = recognizer.translationInView(self)
            self.dummyCell?.center.x = dummyCellCenter.x + fingerTranslation.x
            self.dummyCell?.center.y = dummyCellCenter.y + fingerTranslation.y
            
            if dummyCell?.center.y < (CGRectGetMinY(self.bounds) + self.scrollEdgeInsets.top) {
                setupScrollTimerInDirection( .UP )
            } else if dummyCell?.center.y >
                (CGRectGetMaxY(self.bounds) - self.scrollEdgeInsets.bottom) {
                setupScrollTimerInDirection( .DOWN )
            } else if dummyCell?.center.x <
                (CGRectGetMinX(self.bounds) + self.scrollEdgeInsets.left) {
                setupScrollTimerInDirection( .LEFT )
            } else if dummyCell?.center.x >
                (CGRectGetMaxX(self.bounds) - self.scrollEdgeInsets.right) {
                setupScrollTimerInDirection( .RIGHT )
            } else {
                invalidatesScrollTimer()
            }
        }

        if scrollDirection != .UNKNOWN {
            return
        }

        if let nextToIndexPath = self.indexPathAtPoint(dummyCell!.center) {
            reflectIndexPath( nextToIndexPath)
        }
    }
    
    /**
     ピンチ時の動作
     
     - parameter recognizer: ジェスチャ
     */
    func updateScaleGesture(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            startedScale = currentScale
            startContentOffset = contentOffset
            print("start sclae:\(startedScale)")
            print("start content x:\(startContentOffset.x) y:\(startContentOffset.y)")
            return
        case .Changed:
            //print("contentSize w:\(contentSize.width) h:\(contentSize.height)")
            //print("bounds w:\(bounds.size.width) h:\(bounds.size.height)")
            let nextScale = startedScale * recognizer.scale
            if nextScale >= 0.5 {
                currentScale = nextScale
                
                //拡縮時、注視点を画面の中心にするため、
                //contentOrigin から画面の中心へのベクトルを拡大させ、contentOffsetを求める
                let width = (startContentOffset.x + self.bounds.size.width/2) * recognizer.scale
                let height = (startContentOffset.y + self.bounds.size.height/2) * recognizer.scale
                contentOffset.x = width - self.bounds.size.width/2
                if contentOffset.x < 0 {
                    contentOffset.x = 0
                }
                contentOffset.y = height - self.bounds.size.height/2
                if contentOffset.y < 0 {
                    contentOffset.y = 0
                }
                //print("sclae:\(currentScale)")
                //print("content x:\(contentOffset.x) y:\(contentOffset.y)")
                
                self.collectionViewLayout.invalidateLayout()
            }
            break
        case .Cancelled, .Ended:
            break
        default:
            break
        }
    }
    
    /**
     移動先のインデックスパスを反映する
     
     - parameter indexPath: 移動先のインデックスパス
     */
    private func reflectIndexPath( indexPath: NSIndexPath ) {
        
        if toIndexPath?.isEqual( indexPath ) == false {
            self.performBatchUpdates({() -> Void in
                self.toIndexPath = indexPath
                self.hiddenIndexPath = indexPath
                }, completion:nil)
        }
    }
    
    /**
     ドラッグ中のスクロール動作処理を停止する
     */
    private func invalidatesScrollTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        scrollDirection = .UNKNOWN
    }

    /**
     ドラッグ中のスクロール処理を開始する
     
     - parameter direction: スクロール方向
     */
    private func setupScrollTimerInDirection(direction: ScrollDirection ) {
        scrollDirection = direction
        if timer == nil {
            timer = CADisplayLink(target: self, selector: #selector(DraggableCollectionView.moveScroll(_:)))
            timer?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }
    }
    
    /**
     ドラッグ中のスクロール処理
     
     - parameter timer: timer
     */
    func moveScroll(timer: NSTimer) {
        guard scrollDirection != .UNKNOWN else {
            return
        }
        
        let frameSize = self.bounds.size
        let contentSize = self.contentSize
        let contentOffset = self.contentOffset
        var distance = self.scrollSpeed / 60
        var translation = CGPoint.zero
        
        switch scrollDirection {
            case .UP:
                distance = -distance
                if (contentOffset.y + distance) <= 0 {
                    distance = -contentOffset.y
                }
                translation = CGPoint(x:0, y:distance)
                break
            case .DOWN:
                let maxY = max(contentSize.height, frameSize.height) - frameSize.height
                if (contentOffset.y + distance) >= maxY {
                    distance = maxY - contentOffset.y
                }
                translation = CGPoint(x:0, y:distance)
                break
            case .LEFT:
                distance = -distance
                if (contentOffset.x + distance) <= 0 {
                    distance = -contentOffset.x
                }
                translation = CGPoint(x:distance, y:0)
                break
            case .RIGHT:
                let maxX = max(contentSize.width, frameSize.width) - frameSize.width
                if (contentOffset.x + distance) >= maxX {
                    distance = maxX - contentOffset.x
                }
                translation = CGPoint(x:distance, y:0)
                break
            default:
                break
        }
        
        dummyCellCenter.x  += translation.x
        dummyCellCenter.y  += translation.y
        dummyCell?.center.x = dummyCellCenter.x + fingerTranslation.x
        dummyCell?.center.y = dummyCellCenter.y + fingerTranslation.y
        self.contentOffset.x += translation.x
        self.contentOffset.y += translation.y
        
        if let nextToIndexPath = self.indexPathAtPoint(dummyCell!.center) {
            reflectIndexPath( nextToIndexPath)
        }
    }
}
