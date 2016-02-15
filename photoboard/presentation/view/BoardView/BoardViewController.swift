//
//  BoardViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2015/12/31.
//  Copyright © 2015 tohrinagi. All rights reserved.
//

import UIKit
import Photos

class BoardViewController: UIViewController, UINavigationControllerDelegate {
    
    private var presenter = PresenterContainer.sharedInstance.boardPresenter
    private var images : [[UIImage]] = [[]]
    private var boardBody : BoardBody? = nil
    
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
        presenter.eventHandler = nil
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
    
    /**
     URL から Image を生成する処理
     
     - parameter photo: BoardPhoto
     */
    private func generateUrlToImage(photo: BoardPhoto) {
        
        let options = PHFetchOptions()
        options.includeHiddenAssets = true
        NSLog(photo.referenceURL.absoluteString)
        let fetchResult = PHAsset.fetchAssetsWithALAssetURLs([photo.referenceURL], options: options)
        let asset = fetchResult.firstObject as! PHAsset
     
        PHImageManager().requestImageForAsset(asset,
            targetSize: CGSize(width: 320, height: 320),
            contentMode: .AspectFill, options: nil) {
                image, info in
                
                //let isDegraded = info?[PHImageResultIsDegradedKey]?.boolValue ?? false
                //if isDegraded {
                    //TODO 低解像度の置き換え処理
                //} else {
                while self.images.count <= photo.section {
                    self.images.append([])
                }
                while self.images[photo.section].count <= photo.row {
                    self.images[photo.section].append(UIImage())
                }
                self.images[photo.section][photo.row] = image!
                //}
                self.boardCollectionView?.reloadData()
        }
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
            presenter.addPhoto(boardBody!, referenceUrl: url.absoluteString, section: 0, row: images[0].count)
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
        return images.count
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
        
        cell.imageView.image = images[indexPath.section][indexPath.row]
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
        return images[section].count
    }
    
    /**
     アイテムを移動させた時に呼ばれる
     protocol DraggableCollectionDataSource
     
     - parameter collectionView:       collectionView
     - parameter sourceIndexPath:      移動元
     - parameter destinationIndexPath: 移動先
     */
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    
        //TODO モデルに入れ替え通知
        let sourceImage = images[sourceIndexPath.section].removeAtIndex(sourceIndexPath.row)
        images[destinationIndexPath.section].insert(sourceImage, atIndex: destinationIndexPath.row)
        NSLog("srcSec:\(sourceIndexPath.section) srcRow:\(sourceIndexPath.row) -> dstSec:\(destinationIndexPath.section) dstRow:\(destinationIndexPath.row)")
        presenter.movePhoto(boardBody!, from: sourceIndexPath, to: destinationIndexPath)
    }
 
    /**
     移動完了した時に呼ばれる
     protocol DraggableCollectionDataSource
     
     - parameter collectionView: collectionView
     */
    func finishedMove(collectionView: UICollectionView ) {
        NSLog("finishedMove")
        //セクションを増やす処理
        let last = images.count - 1
        if images[last].count != 0 {
            images.append([])
        } else {
            if last > 0 {
                if images[last-1].count == 0 {
                    images.removeAtIndex(last)
                }
            }
        }
        //セクションを増減させたので、リロード
        collectionView.reloadData()
    }
}

extension BoardViewController : BoardPresenterEventHandler {
    func OnLoadedBoard(board: BoardBody) {
        NSLog("OnLoadedBoard")
        boardBody = board
        
        for photo in boardBody?.photos ?? [] {
            generateUrlToImage( photo )
        }
    }
    
    func OnAddedPhoto(photo: BoardPhoto) {
        generateUrlToImage(photo)
    }
    
    func OnMovePhoto(fromPhoto: BoardPhoto, toPhoto: BoardPhoto) {
        NSLog("OnMovePhoto")
    }
}
