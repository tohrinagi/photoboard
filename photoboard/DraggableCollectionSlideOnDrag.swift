//
//  DraggableCollectionSlideOnDrag.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/09.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//
import UIKit

class DraggableCollectionSlideOnDrag {
    
    let collectionView : DraggableCollectionView
    
    init( collectionView :DraggableCollectionView) {
        self.collectionView = collectionView
    }
    
    func layoutAttributesForElementsInRectOnDrag( attributes : [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes]? {
 
        func moveOnDragForSameSection( attribute :UICollectionViewLayoutAttributes ) {
         
            guard attribute.representedElementCategory == UICollectionElementCategory.Cell else {
                return
            }
            
            print("moveOnDragForSameSection row:\(attribute.indexPath.row) sec:\(attribute.indexPath.section)")
            if attribute.indexPath.isEqual(collectionView.toIndexPath!) {
                attribute.indexPath = NSIndexPath(forRow: collectionView.fromIndexPath!.row, inSection: collectionView.fromIndexPath!.section)
            } else if attribute.indexPath.section == collectionView.fromIndexPath!.section {
                if collectionView.fromIndexPath!.row <= attribute.indexPath.row && attribute.indexPath.row < collectionView.toIndexPath!.row {
                    
                    attribute.indexPath = NSIndexPath(forRow: attribute.indexPath.row + 1,
                        inSection: attribute.indexPath.section)
                } else if collectionView.fromIndexPath!.row >= attribute.indexPath.row && attribute.indexPath.row > collectionView.toIndexPath!.row {
                    
                    attribute.indexPath = NSIndexPath(forRow: attribute.indexPath.row - 1,
                        inSection: attribute.indexPath.section)
                }
            }
            print("moveOnDragForSameSection end row:\(attribute.indexPath.row) sec:\(attribute.indexPath.section)")
        }
        
        func moveOnDragForOtherSection( attribute :UICollectionViewLayoutAttributes, lastFromIndexPath :NSIndexPath ) {
        
            guard attribute.representedElementCategory == UICollectionElementCategory.Cell else {
                return
            }
            print("moveOnDragForOtherSection row:\(attribute.indexPath.row) sec:\(attribute.indexPath.section)")
            //単純にIndexPathを書き換えるとSectionごとのアイテム数が合わなくなりエラーになる。
            //そのため移動元セクションのセルを移動先セクションへ移動する
            if attribute.indexPath.isEqual(lastFromIndexPath) {
                let numRowOfToIndex = collectionView.numberOfItemsInSection( collectionView.toIndexPath!.section )
                attribute.indexPath = NSIndexPath(forRow: numRowOfToIndex, inSection: collectionView.toIndexPath!.section)
                if attribute.indexPath.row != 0 {
                    attribute.center = collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath( attribute.indexPath)!.center
                }
                if attribute.indexPath.isEqual(collectionView.hiddenIndexPath!) {
                   attribute.hidden = true
                }
            }
            if attribute.indexPath.isEqual(collectionView.toIndexPath!) {
                attribute.indexPath = NSIndexPath(forRow: collectionView.fromIndexPath!.row, inSection: collectionView.fromIndexPath!.section)
            } else if attribute.indexPath.section == collectionView.fromIndexPath!.section {
            //移動元のセクションはそこを詰める
                if attribute.indexPath.row >= collectionView.fromIndexPath!.row {
                    attribute.indexPath = NSIndexPath(forItem: attribute.indexPath.row+1, inSection: attribute.indexPath.section)
                }
            } else if attribute.indexPath.section == collectionView.toIndexPath!.section {
            //移動先のセクションは挿入するため１つずつずらす
                if attribute.indexPath.row >= collectionView.toIndexPath!.row {
                    attribute.indexPath = NSIndexPath(forRow: attribute.indexPath.row-1, inSection: attribute.indexPath.section)
                }
            }
            print("moveOnDragForOtherSection end row:\(attribute.indexPath.row) sec:\(attribute.indexPath.section)")
        }
        
        //ドラッグはダミーのセルで行うので、元のセルを消す
        //下記のtoIndex, fromIndexのガードの外なのは、長押しキャンセル時のanimateWithDurationのときセルが二重に見えるのを防ぐため
        if collectionView.hiddenIndexPath != nil {
            attributes.forEach({ (attribute:UICollectionViewLayoutAttributes) -> () in
                if attribute.indexPath.isEqual(collectionView.hiddenIndexPath!) {
                   attribute.hidden = true
                }
            })
        }
        //ドラッグ中でなければ何もしない
        guard collectionView.toIndexPath != nil && collectionView.fromIndexPath != nil else {
                print("noTo,From")
            return attributes
        }
        print("toIndexPath row:\(collectionView.toIndexPath!.row) sec:\(collectionView.toIndexPath!.section)")
        print("fromIndexPath row:\(collectionView.fromIndexPath!.row) sec:\(collectionView.fromIndexPath!.section)")
        print("hiddenIndexPath row:\(collectionView.hiddenIndexPath!.row) sec:\(collectionView.hiddenIndexPath!.section)")
        
        if collectionView.toIndexPath!.section == collectionView.fromIndexPath!.section {
            //同じセクション内ドラッグ
            attributes.forEach(moveOnDragForSameSection)
            return attributes
        } else {
            //別セクションでドラッグ
            let lastFromIndexRow = collectionView.numberOfItemsInSection(collectionView.fromIndexPath!.section)-1
            let lastFromIndexPath = NSIndexPath(forRow: lastFromIndexRow, inSection: collectionView.fromIndexPath!.section )
            for attribute in attributes {
                moveOnDragForOtherSection(attribute, lastFromIndexPath: lastFromIndexPath)
            }
            return attributes
        }
    }
}