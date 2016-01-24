//
//  DraggableCollectionView.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/06.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import UIKit

class DraggableCollectionView : UICollectionView, UIGestureRecognizerDelegate {
    
    private var dummyCell : UIImageView?
    private var dummyCellCenter : CGPoint = CGPointZero
    var fromIndexPath : NSIndexPath?
    var toIndexPath : NSIndexPath?
    var hiddenIndexPath : NSIndexPath?
    private var longPressGestureRecognizer : UILongPressGestureRecognizer!
    private var panPressGestureRecognizer : UIPanGestureRecognizer!
    private var scrollDirection = ScrollDirection.UNKNOWN
    private var timer : CADisplayLink? = nil
    private var fingerTranslation : CGPoint = CGPointZero
    var scrollEdgeInsets : UIEdgeInsets = UIEdgeInsetsMake(50, 50, 50, 50)
    var scrollSpeed : CGFloat = 400
    
    
    var enabled : Bool
    {
        get {
            return self.enabled
        }
        set {
            self.enabled = newValue
            longPressGestureRecognizer.enabled = newValue
            panPressGestureRecognizer.enabled = newValue
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
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:"updateLongPressGesture:")
        longPressGestureRecognizer.delegate = self
        panPressGestureRecognizer = UIPanGestureRecognizer(target: self, action: "updatePanPressGesture:")
        panPressGestureRecognizer.delegate = self
        
        self.addGestureRecognizer(longPressGestureRecognizer)
        self.addGestureRecognizer(panPressGestureRecognizer)
        /*
        for gestureRecognizer in self.gestureRecognizers! {
            if gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer.self) {
                gestureRecognizer.requireGestureRecognizerToFail(longPressGestureRecognizer)
                break;
            }
        }*/
       
    }
    
    private func createDummyCell(cell:UICollectionViewCell) -> UIImageView {
        let imageView = UIImageView(frame: cell.frame)
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.opaque, 0)
        cell.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = image
        
        imageView.layer.shadowOffset = CGSizeMake(8, 8)
        imageView.layer.shadowOpacity = 0.8
        
        return imageView
    }
    
    private func indexPathAtPoint( point : CGPoint ) -> NSIndexPath? {
        let numSection = self.numberOfSections() ?? 0
        for section in 0..<numSection {
            var numCell = self.numberOfItemsInSection(section) ?? 0
            
            //セクションをまたぐとき他のセクションの後尾にドラッグできるようにする
            if fromIndexPath?.section != section {
                numCell += 1
            }
            
            for cell in 0..<numCell {
                let indexPath = NSIndexPath(forItem: cell, inSection: section)
                if let attribute = self.collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath) {
                    let rect = CGRect(x: attribute.center.x - attribute.size.width/2, y: attribute.center.y - attribute.size.height/2, width: attribute.size.width, height: attribute.size.height )
                    if CGRectContainsPoint( rect, point ) {
                        return indexPath
                    }
                }
            }
        }
        return nil
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(self.panPressGestureRecognizer) {
            return fromIndexPath != nil
        }
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(self.longPressGestureRecognizer) {
            return otherGestureRecognizer.isEqual(self.panPressGestureRecognizer)
        }
        if gestureRecognizer.isEqual(self.panPressGestureRecognizer) {
            return otherGestureRecognizer.isEqual(self.longPressGestureRecognizer)
        }
        return false
    }
 
    func updateLongPressGesture(recognizer : UILongPressGestureRecognizer) {
        
        switch recognizer.state {
        case .Began:
            guard let indexPath = self.indexPathForItemAtPoint(recognizer.locationInView(self)) else {
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
                ()->Void in self.dummyCell!.transform = CGAffineTransformMakeScale(1.1, 1.1) }
            )
            
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
                dataSource.collectionView!(self, moveItemAtIndexPath: fromIndexPath!, toIndexPath:toIndexPath!)
            }
            
            self.performBatchUpdates({
                    ()->Void in
                    self.moveItemAtIndexPath(self.fromIndexPath!, toIndexPath: self.toIndexPath!)
                    self.fromIndexPath = nil
                    self.toIndexPath = nil
                print("performBatchUpdates")
                }, completion:nil)
            //ダミーセルが狙ったセルに移動する処理
            UIView.animateWithDuration(0.1, animations: {
                    ()->Void in
                    let fromAttribute = self.layoutAttributesForItemAtIndexPath(self.hiddenIndexPath!)
                    self.dummyCell!.center = fromAttribute!.center
                    self.dummyCell!.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: {
                    (finished:Bool)->Void in
                    self.dummyCell?.removeFromSuperview()
                    self.dummyCell = nil
                    self.hiddenIndexPath = nil
                    self.collectionViewLayout.invalidateLayout()
                    print("end animateWithDuration")
                    if let dataSource = self.dataSource as? DraggableCollectionDataSource {
                        dataSource.finishedMove(self)
                    }
                    self.collectionViewLayout.invalidateLayout()
                } )
            self.invalidatesScrollTimer()
            break
        default:
            break
        }
    }
    
    func updatePanPressGesture(recognizer:UIPanGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Changed {
            fingerTranslation = recognizer.translationInView(self)
            self.dummyCell?.center.x = dummyCellCenter.x + fingerTranslation.x
            self.dummyCell?.center.y = dummyCellCenter.y + fingerTranslation.y
            
            if (dummyCell?.center.y < (CGRectGetMinY(self.bounds) + self.scrollEdgeInsets.top)) {
                setupScrollTimerInDirection( .UP )
            } else if (dummyCell?.center.y > (CGRectGetMaxY(self.bounds) - self.scrollEdgeInsets.bottom)) {
                setupScrollTimerInDirection( .DOWN )
            } else if (dummyCell?.center.x < (CGRectGetMinX(self.bounds) + self.scrollEdgeInsets.left)) {
                setupScrollTimerInDirection( .LEFT )
            } else if (dummyCell?.center.x > (CGRectGetMaxX(self.bounds) - self.scrollEdgeInsets.right)) {
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
    
    private func reflectIndexPath( indexPath : NSIndexPath ) {
        
        if toIndexPath?.isEqual( indexPath ) == false {
            self.performBatchUpdates({()->Void in
                self.toIndexPath = indexPath
                self.hiddenIndexPath = indexPath
                }, completion:nil)
        }
    }
    
    private func invalidatesScrollTimer() {
        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }
        scrollDirection = .UNKNOWN
    }

    private func setupScrollTimerInDirection(direction : ScrollDirection ) {
        scrollDirection = direction
        if (timer == nil) {
            timer = CADisplayLink(target: self, selector: "moveScroll:")
            timer?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }
    }
    
    func moveScroll(timer:NSTimer) {
        guard scrollDirection != .UNKNOWN else {
            return
        }
        
        let frameSize = self.bounds.size
        let contentSize = self.contentSize
        let contentOffset = self.contentOffset
        var distance = self.scrollSpeed / 60
        var translation = CGPointZero
        
        switch scrollDirection {
            case .UP:
                distance = -distance
                if ((contentOffset.y + distance) <= 0) {
                    distance = -contentOffset.y
                }
                translation = CGPointMake(0, distance)
                break
            case .DOWN:
                let maxY = max(contentSize.height, frameSize.height) - frameSize.height
                if ((contentOffset.y + distance) >= maxY) {
                    distance = maxY - contentOffset.y
                }
                translation = CGPointMake(0, distance)
                break
            case .LEFT:
                distance = -distance
                if ((contentOffset.x + distance) <= 0) {
                    distance = -contentOffset.x
                }
                translation = CGPointMake(distance, 0)
                break
            case .RIGHT:
                let maxX = max(contentSize.width, frameSize.width) - frameSize.width
                if ((contentOffset.x + distance) >= maxX) {
                    distance = maxX - contentOffset.x
                }
                translation = CGPointMake(distance, 0)
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
