//
//  BoardViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2015/12/31.
//  Copyright © 2015 tohrinagi. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, UINavigationControllerDelegate {
    
    private var presenter = PresenterContainer.sharedInstance.boardPresenter
    private var boardBody : BoardBody? = nil
    private var bodyViewModel : BoardBodyViewModel? = nil
    
    @IBOutlet weak private var boardCollectionView: BoardCollectionView?
    
    
    /**
     開始読み込み
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("viewDidLoad")
    }
    
    /**
     新しく作成した時のセットアップ
     */
    func setup( boardInfo : BoardInfo){
        NSLog("setupForNew:"+boardInfo.title)
        presenter.eventHandler = self
        presenter.loadBoardBody(boardInfo)
    }
    
    /**
     終了
     
     - parameter animated: anime
     */
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //TODO カメラの戻りでプレゼンター使えなくなる
        //presenter.eventHandler = nil
    }
    
    //TODO
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //NSLog(segue.debugDescription)
    }
    
    /**
     「Camera」ボタンをタッチした時の呼ばれる
     
     - parameter sender:
     */
    @IBAction func cameraTouchUpInsideHandler(sender: AnyObject) {
        guard !CameraControllerFactory.isAvailable() else {
            return
        }
        
        let cameraController = CameraControllerFactory.Generate()
        cameraController.delegate = self
        // 撮影画面をモーダルビューとして表示する
        self.presentViewController(cameraController, animated: true, completion: nil)
    }
    
}

extension BoardViewController : UIImagePickerControllerDelegate {
    /**
    画像が選択されたときによばれる
    
    - parameter picker: イメージ選択コントローラ
    - parameter info: 選択したメディア情報
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        // モーダルビューを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
        // 画像があったらBoardScrollViewに追加
        if let url = info[UIImagePickerControllerReferenceURL] as? NSURL {
            presenter.addPhoto(boardBody!, referenceUrl: url.absoluteString, section: 0, row: bodyViewModel!.numberOfItems(0))
        }
    }
    
    /**
    画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
    
    - parameter picker: イメージ選択コントローラ
    */
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        // モーダルビューを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
        //TODO キャンセルされたときの処理を記述・・・
    }
}

extension BoardViewController : DraggableCollectionDataSource, UICollectionViewDelegate {
    
    /**
     セクションの数を返す protocol DraggableCollectionDataSource
     
     - parameter collectionView: collectionView
     
     - returns: セクション数
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return bodyViewModel?.numberOfSections() ?? 0
    }
    
    /**
     インデックスパスに応じたセルを作成して返す
     protocol DraggableCollectionDataSource
     
     - parameter collectionView: collectionView
     - parameter indexPath:      セルの位置のインデックスパス
     
     - returns: 作成したセル
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = boardCollectionView?.dequeueReusableCellWithReuseIdentifier("BoardCell", forIndexPath: indexPath) as! BoardCollectionViewCell
        
        cell.imageView.image = bodyViewModel!.photo(indexPath)
        return cell
    }
    
    /**
     セクションに応じたアイテム数を返す
     protocol DraggableCollectionDataSource
    
     - parameter collectionView: collectionView
     - parameter section:        セクション
     
     - returns: 指定したセクションごとのアイテム数
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bodyViewModel?.numberOfItems(section) ?? 0
    }
    
    /**
     アイテムを移動させた時に呼ばれる
     protocol DraggableCollectionDataSource
     
     - parameter collectionView:       collectionView
     - parameter sourceIndexPath:      移動元
     - parameter destinationIndexPath: 移動先
     */
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        //早く反応させるために、OnMovePhoto をまたない
        bodyViewModel?.movePhoto(sourceIndexPath, to: destinationIndexPath)
        presenter.movePhoto(boardBody!, from: sourceIndexPath, to: destinationIndexPath)
    }
 
    /**
     移動完了した時に呼ばれる
     protocol DraggableCollectionDataSource
     
     - parameter collectionView: collectionView
     */
    func finishedMove(collectionView: UICollectionView ) {
        NSLog("finishedMove")
        bodyViewModel?.updateBlankSection()
        //セクションを増減させたので、リロード
        collectionView.reloadData()
    }
}

extension BoardViewController : BoardPresenterEventHandler {
    func OnLoadedBoard(board: BoardBody) {
        NSLog("OnLoadedBoard")
        boardBody = board
        bodyViewModel = BoardBodyViewModel(boardBody: board)
        
        bodyViewModel!.generateImageAll{
            self.boardCollectionView?.reloadData()
        }
    }
    
    func OnAddedPhoto(photo: BoardPhoto) {
        bodyViewModel?.generateImage(photo, completion: { () -> Void in
            self.boardCollectionView?.reloadData()
        })
    }
    
    func OnMovePhoto(from: NSIndexPath, to: NSIndexPath) {
        NSLog("OnMovePhoto")
    }
}
