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
    var boardInfoList : BoardInfoList? = nil
    
    @IBOutlet weak var homeCollectionView: HomeCollectionView!
    
    /**
     ViewDidLoad 開始読み込み
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.eventHandler = self
        presenter.loadBoardInfoList()
    }

    /**
     次 ViewController の準備
     
     - parameter segue:  セグエ
     - parameter sender: sender
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Segueの特定
        if segue.identifier == "Add" {
            let nextViewController = segue.destinationViewController as! BoardViewController;
            nextViewController.setupForNew()
        }
    }
}

extension HomeViewController : DraggableCollectionDataSource, UICollectionViewDelegate {
 
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
        return boardInfoList?.items.count ?? 0
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
    
    func OnLoadedBoards(boardInfoList: BoardInfoList) {
        //TODO
        images = []
        for _ in boardInfoList.items {
            //let image = UIImage(named: item.)
            if let image = UIImage(named: "cat.jpg") {
                images.append(image)
            }
        }
        self.boardInfoList = boardInfoList
        self.homeCollectionView.reloadData()
    }
}