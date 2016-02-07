//
//  DraggableCollectionDataSource.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/09.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import UIKit

protocol DraggableCollectionDataSource : UICollectionViewDataSource {
    
    /**
     セクション毎のアイテム数
     
     - parameter collectionView: collecctionView
     - parameter section:        セクション
     
     - returns: セクション毎のアイテム数
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    /**
     インデックスパス対応するセルを作成して返す
     
     - parameter collectionView: collectionView
     - parameter indexPath:      作成するセルのインデックスパス
     
     - returns: セル
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    
    /**
     移動完了した時に呼ばれる
     
     - parameter collectionView: collectionView
     */
    func finishedMove(collectionView: UICollectionView )
}