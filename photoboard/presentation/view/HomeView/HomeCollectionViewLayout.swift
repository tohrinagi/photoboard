//
//  HomeCollectionViewLayout.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/30.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//
import UIKit

class HomeCollectionViewLayout : UICollectionViewFlowLayout {
    
    lazy var draggableCollectionView : DraggableCollectionView = {
        ()->DraggableCollectionView in
        return self.collectionView as! DraggableCollectionView
    }()
    lazy var moveOnDrag : DraggableCollectionSlideOnDrag = {
        ()->DraggableCollectionSlideOnDrag in
        return DraggableCollectionSlideOnDrag(collectionView: self.draggableCollectionView)
    }()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     レイアウト計算準備に呼ばれる override UICollectionViewFlowLayout
     */
    override func prepareLayout() {
        self.itemSize.height = 100;
        self.itemSize.width = draggableCollectionView.bounds.width
        self.scrollDirection = .Vertical
        draggableCollectionView.zoomable = false
    }
    
    /**
     引数のRectで指定されたエリアに存在するCell群のレイアウト情報を返す
     override UICollectionViewFlowLayout
     
     - parameter rect: 表示するセルのエリア
     
     - returns: 表示するセルのレイアウト情報
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElementsInRect(rect)
        return moveOnDrag.layoutAttributesForElementsInRectOnDrag( attributes! ) ?? attributes
    }
}