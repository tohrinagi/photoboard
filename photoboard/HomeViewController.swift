//
//  HomeViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2015/12/31.
//  Copyright © 2016 tohrinagi. All rights reserved.
//

import UIKit

/// 開始画面管理コントローラ
class HomeViewController: UIViewController {
    var presenter = PresenterContainer.sharedInstance.homePresenter
    var images : [UIImage] = []
    
    @IBOutlet weak var homeCollectionView: HomeCollectionView!
    
    /**
     ViewDidLoad 開始読み込み
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.eventHandler = self
        presenter.loadBoards()
        
        //TODO
        if let image = UIImage(named: "cat.jpg") {
            images.append(image)
        }
    }

}

extension HomeViewController : DraggableCollectionDataSource, UICollectionViewDelegate {
    
    /**
     セクション数を返す DraggableCollectionDataSource protocol 実装
     
     - parameter collectionView: collectionView
     
     - returns: セクション数
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
 
    /**
     インデックスパスに対応するセルを作る DraggableCollectionDataSource protocol 実装
    
     - parameter collectionView: collectionView
     - parameter indexPath:      作るセルのインデックスパス
     
     - returns: セル
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCollectionViewCell
        
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    /**
     セクションごとのアイテム数を返す DraggableCollectionDataSource protocol 実装
     
     - parameter collectionView: collectionView
     - parameter section:        セクション
     
     - returns: セクションのアイテム数
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    /**
     アイテムが移動するの処理 DraggableCollectionDataSource protocol 実装
     
     - parameter collectionView:       collectionView
     - parameter sourceIndexPath:      移動元
     - parameter destinationIndexPath: 移動先
     */
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    
        //TODO モデルに入れ替え通知
        let sourceImage = images.removeAtIndex(sourceIndexPath.row)
        images.insert(sourceImage, atIndex: destinationIndexPath.row)
        print("srcSec:\(sourceIndexPath.section) srcRow:\(sourceIndexPath.row) -> dstSec:\(destinationIndexPath.section) dstRow:\(destinationIndexPath.row)")
    }
    
    /**
     移動完了時に呼ばれる
     
     - parameter collectionView: collectionView
     */
    func finishedMove(collectionView: UICollectionView ) {
        print("finishedMove")
    }
}

extension HomeViewController : HomePresenterEventHandler {
    
    func OnLoadedBoards(){
    }
}