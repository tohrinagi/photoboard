//
//  BoardCollectionViewLayout.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/04.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import UIKit

class BoardCollectionViewLayout : UICollectionViewLayout {
    
    var minimumInteritemSpacing: CGSize = CGSize(width: 0, height: 0)
    var itemSize: CGSize = CGSize(width: 200, height: 200)
    lazy var moveOnDrag : DraggableCollectionSlideOnDrag? = {
        ()->DraggableCollectionSlideOnDrag in
        let draggableCollectionView = self.collectionView as! DraggableCollectionView
        return DraggableCollectionSlideOnDrag(collectionView: draggableCollectionView)
    }()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        //TODO 毎回計算してくてもよい？
        let width = itemSize.width + minimumInteritemSpacing.width
        let height = itemSize.height + minimumInteritemSpacing.height
        
        let numSection = collectionView?.numberOfSections() ?? 0
        var sectionLength = numSection
        
        //後ろから長さが０のセクションは詰める。
        for section in (0..<numSection).reverse() {
            let numCell = collectionView?.numberOfItemsInSection(section) ?? 0
            if numCell != 0 {
                break
            }
            sectionLength--
        }
        
        //一番長いROWに合わせる
        var mostNumCell = 0
        for section in 0..<numSection {
            let numCell = collectionView?.numberOfItemsInSection(section) ?? 0
            if numCell > mostNumCell {
                mostNumCell = numCell
            }
        }
        
        var contentWidth = width * CGFloat(sectionLength)
        var contentHeight = height * CGFloat(mostNumCell)
        
        let bounds = collectionView?.bounds ?? CGRectZero
        var dragHeight = height
        var dragWidth = width
        if contentWidth < bounds.width {
            contentWidth = bounds.width
            dragWidth = 0
        }
        if contentHeight < bounds.height {
            contentHeight = bounds.height
            dragHeight = 0
        }
        
        let sizeOnNormal = CGSize(width: contentWidth, height: contentHeight)
        let sizeOnDrag = CGSize(width: contentWidth + dragWidth, height: contentHeight + dragHeight )
        return moveOnDrag?.collectionViewContentSizeOnDrag( sizeOnNormal, sizeOnDrag: sizeOnDrag ) ?? sizeOnNormal
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        let width = itemSize.width + minimumInteritemSpacing.width
        let height = itemSize.height + minimumInteritemSpacing.height
        let x = Int(width/2) + Int(width * CGFloat(indexPath.section))
        let y = Int(height/2) + Int(height * CGFloat(indexPath.row))
        attributes.center = CGPoint(x: x, y: y)
        attributes.size = CGSize(width: itemSize.width, height: itemSize.height)
        return attributes
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        
        //TODO 最適化:当たり判定を少なくする
        let numSection = collectionView?.numberOfSections() ?? 0
        for section in 0..<numSection {
            let numCell = collectionView?.numberOfItemsInSection(section) ?? 0
            for cell in 0..<numCell {
                let indexPath = NSIndexPath(forItem: cell, inSection: section)
                let attribute = layoutAttributesForItemAtIndexPath(indexPath)
                let origin = CGPoint( x :attribute!.center.x - attribute!.size.width/2, y: attribute!.center.x - attribute!.size.height/2 )
                let itemRect = CGRect(origin: origin, size: attribute!.size)
                if CGRectIntersectsRect( rect, itemRect ) {
                    attributes.append(attribute!)
                }
            }
        }
        return moveOnDrag?.layoutAttributesForElementsInRectOnDrag( attributes ) ?? attributes
    }
}