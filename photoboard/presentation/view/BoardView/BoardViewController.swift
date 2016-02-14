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
    
    private var boardPresenter = PresenterContainer.sharedInstance.boardPresenter
    private var images : [[UIImage]] = [[]]
    private var boardBody : BoardBody? = nil
    
    @IBOutlet weak private var boardCollectionView: BoardCollectionView!
    
    
    /**
     開始読み込み
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        boardPresenter.eventHandler = self
        print("viewDidLoad")
    }
    
    /**
     新しく作成した時のセットアップ
     */
    func setup( boardInfo : BoardInfo){
        print("setupForNew:"+boardInfo.title)
        boardPresenter.loadBoardBody(boardInfo)
    }
    
    //TODO
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print(segue.debugDescription)
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
    
    //TODO 確認用コード
    var a = 0
    
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
                
                let isDegraded = info?[PHImageResultIsDegradedKey]?.boolValue ?? false
                if isDegraded {
                    //TODO 低解像度の置き換え処理
                } else {
                    if self.images.count <= self.a {
                        self.images.append([])
                    }
                    //TODO ない場合
                    self.images[self.a].append(image!)
                    self.a ^= 1
                    self.boardCollectionView.reloadData()
                }
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
        let url = info[UIImagePickerControllerReferenceURL] as! NSURL
        //TODO section, row
        boardPresenter.addPhoto(boardBody!, referenceUrl: url.absoluteString, section: 0, row: 0)
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
        let cell = boardCollectionView.dequeueReusableCellWithReuseIdentifier("BoardCell", forIndexPath: indexPath) as! BoardCollectionViewCell
        
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
/*
        if destinationIndexPath.section == images.count - 1 {
            if images[ images.count-1].count > 0 {
                images.append([])
            }
        }
        if sourceIndexPath.section == images.count - 1 {
            if images[ images.count-1].count == 0 {
                images.removeAtIndex(images.count-1)
            }
        }
  */      
        print("srcSec:\(sourceIndexPath.section) srcRow:\(sourceIndexPath.row) -> dstSec:\(destinationIndexPath.section) dstRow:\(destinationIndexPath.row)")
    }
 
    /**
     移動完了した時に呼ばれる
     protocol DraggableCollectionDataSource
     
     - parameter collectionView: collectionView
     */
    func finishedMove(collectionView: UICollectionView ) {
        print("finishedMove")
        //TODO モデルでセクションを増やす処理
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
        boardBody = board
        
        for photo in boardBody?.photos ?? [] {
            generateUrlToImage( photo )
        }
    }
    
    func OnAddedPhoto(photo: BoardPhoto) {
        generateUrlToImage(photo)
    }
}
