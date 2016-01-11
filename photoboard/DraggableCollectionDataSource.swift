//
//  DraggableCollectionDataSource.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/09.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import UIKit

protocol DraggableCollectionDataSource : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    /*
    optional func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool
*/
}