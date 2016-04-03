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
    private var presenter = PresenterContainer.sharedInstance.homePresenter
    private var homeViewModel: HomeViewModel? = nil
    
    @IBOutlet weak private var homeCollectionView: HomeCollectionView!
    
    /**
     ViewDidLoad 開始読み込み
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    /**
     開始
     
     - parameter animated: anime
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presenter.eventHandler = self
        presenter.loadBoardInfoList()
    }
    
    /**
     終了
     
     - parameter animated: anime
     */
    override func viewDidDisappear(animated: Bool) {
        presenter.eventHandler = nil
    }

    /**
     次 ViewController の準備
     
     - parameter segue:  セグエ
     - parameter sender: sender
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "HomeToBoard":
            if let info = sender as? BoardInfo {
                let nextViewController = segue.destinationViewController as! BoardViewController
                nextViewController.setup( info )
            }
        case "HomeToInfoBoard":
            let navigationController = segue.destinationViewController as! UINavigationController
            let nextViewController = navigationController.topViewController
                as! InfoBoardViewController
            nextViewController.delegate = self
        default :
            break
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
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCellWithReuseIdentifier(
            "HomeCell", forIndexPath: indexPath) as! HomeCollectionViewCell
        
        //TODO ViewModelにする
        cell.imageView.image = homeViewModel?.photo(indexPath)
        cell.dateLabel.text = homeViewModel?.boardInfoList[indexPath.row].updatedString()
        cell.titleLabel.text = homeViewModel?.boardInfoList[indexPath.row].title
        return cell
    }
    
    /**
     セクションごとのアイテム数を返す DraggableCollectionDataSource protocol 実装
     
     - parameter collectionView: collectionView
     - parameter section:        セクション
     
     - returns: セクションのアイテム数
     */
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return homeViewModel?.numberOfItems() ?? 0
    }
    
    /**
     アイテムが移動するの処理 DraggableCollectionDataSource protocol 実装
     
     - parameter collectionView:       collectionView
     - parameter sourceIndexPath:      移動元
     - parameter destinationIndexPath: 移動先
     */
    func collectionView(collectionView: UICollectionView,
        moveItemAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
    
        //TODO モデルに入れ替え通知
        homeViewModel?.movePhoto(sourceIndexPath, to: destinationIndexPath)
    }
    
    /**
     移動完了時に呼ばれる
     
     - parameter collectionView: collectionView
     */
    func finishedMove(collectionView: UICollectionView ) {
        print("finishedMove")
    }
    
    /**
     セル選択時
     
     - parameter collectionView: コレクションビュー
     - parameter indexPath:      選択した場所のインデックスパス
     */
    func collectionView(
        collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("selected Sec:\(indexPath.section) Row:\(indexPath.row)")
        let board = homeViewModel?.boardInfoList[indexPath.row]
        self.performSegueWithIdentifier("HomeToBoard", sender: board)
    }
}

extension HomeViewController : HomePresenterEventHandler {
    
    func OnLoadedBoards(boardInfoList: [BoardInfo]) {
        homeViewModel = HomeViewModel(infoList: boardInfoList)
        
        homeViewModel?.generateImageAll {
            //self.boardCollectionView?.reloadData()
            self.homeCollectionView.reloadData()
        }
    }
    
    func OnCreatedNewBoard(board: BoardInfo) {
        //新規作成終わったら移動
        self.performSegueWithIdentifier("HomeToBoard", sender: board)
    }
}

extension HomeViewController : InfoBoardViewControllerDelegate {
    func OnCancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func OnSaveAction(title: String, date: NSDate) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let num = homeViewModel?.numberOfItems() ?? 0
        self.presenter.createNewBoard(title, date: date, row: num)
    }
}
