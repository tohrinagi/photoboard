//
//  DragModule.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/06.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import UIKit

class DragModule : NSObject, UIGestureRecognizerDelegate {
    
    var collectionView : UICollectionView!
    var dummyCell : UIImageView?
    var dummyCellCenter : CGPoint = CGPointZero
    var srcIndexPath : NSIndexPath?
    var dstIndexPath : NSIndexPath?
    var longPressGestureRecognizer : UILongPressGestureRecognizer?
    var panPressGestureRecognizer : UIPanGestureRecognizer?
    
    init(collectionView: UICollectionView){
        self.collectionView = collectionView
        
        super.init()
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:"updateLongPressGesture:")
        longPressGestureRecognizer?.delegate = self
        panPressGestureRecognizer = UIPanGestureRecognizer(target: self, action: "updatePanPressGesture:")
        panPressGestureRecognizer!.delegate = self
        
        self.collectionView.addGestureRecognizer(longPressGestureRecognizer!)
        self.collectionView.addGestureRecognizer(panPressGestureRecognizer!)
    }
    
    private func createDummyCell(cell:UICollectionViewCell) -> UIImageView {
        let imageView = UIImageView(frame: cell.frame)
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.opaque, 0)
        cell.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = image
        return imageView
    }
    
    private func calculateIndexPath( point : CGPoint ) -> NSIndexPath? {
        
        //TODO スクロールしていた場合って、位置どうなるんだろう。
        //centerには相対座標が入っているのかな？
        let numSection = collectionView?.numberOfSections() ?? 0
        for section in 0..<numSection {
            let numCell = collectionView?.numberOfItemsInSection(section) ?? 0
            for cell in 0..<numCell {
                let indexPath = NSIndexPath(forItem: cell, inSection: section)
                if let attribute = self.collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath) {
                    let rect = CGRect(x: attribute.center.x - attribute.size.width/2, y: attribute.center.y - attribute.size.height/2, width: attribute.size.width, height: attribute.size.height )
                    if CGRectContainsPoint( rect, point ) {
                        return indexPath
                    }
                }
            }
        }
        return nil
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(self.panPressGestureRecognizer) {
            return srcIndexPath != nil
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
        
        let point: CGPoint = recognizer.locationInView(collectionView)
        guard let indexPath = calculateIndexPath(point) else {
            return
        }
        
        switch recognizer.state {
        case .Began:
            guard let pressedCell = collectionView.cellForItemAtIndexPath(indexPath) else {
                return
            }
            pressedCell.highlighted = false
            dummyCell?.removeFromSuperview()
            dummyCell = createDummyCell(pressedCell)
            dummyCellCenter = (dummyCell?.center)!
            
            UIView.animateWithDuration(0.3, animations: { ()->Void in self.dummyCell!.transform = CGAffineTransformMakeScale(1.1, 1.1) })
            collectionView.addSubview(dummyCell!)
            
            collectionView.collectionViewLayout.invalidateLayout()
            srcIndexPath = indexPath
            break
        case .Ended, .Cancelled:
            guard srcIndexPath != nil else {
                return
            }
            let layoutAttribute = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
            
            UIView.animateWithDuration(0.3, animations: {
                    ()->Void in
                    self.dummyCell!.center = (layoutAttribute?.center)!
                    self.dummyCell!.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: {
                    (finished:Bool)->Void in
                    self.dummyCell?.removeFromSuperview()
                    self.dummyCell = nil
                    self.srcIndexPath = nil
                    self.collectionView.collectionViewLayout.invalidateLayout()
                } )
            break
        default:
            break
        }
    }
    
    
    func updatePanPressGesture(recognizer:UIPanGestureRecognizer){
        switch( recognizer.state) {
        case .Changed:
            let fingerTranslation = recognizer.translationInView(self.collectionView)
            self.dummyCell?.center.x = dummyCellCenter.x + fingerTranslation.x
            self.dummyCell?.center.y = dummyCellCenter.y + fingerTranslation.y
            break
        default:
            break
        }
    }

}


