//
//  BoardViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2015/12/31.
//  Copyright © 2015 tohrinagi. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, UINavigationControllerDelegate {
    
    var boardPresenter = PresenterContainer.sharedInstance.boardPresenter
    var images : [[UIImage]] = [[]]
    
    @IBOutlet weak var boardCollectionView: BoardCollectionView!
    
    
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
    }
    
    /**
     データを読み込む時のセットアップ
     
     - parameter boardId: ロードするboardId
     */
    func setupForLoad( dataId : Int ) {
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
        //TODOキャッシュ作ったりする？
        if  let originImage = info[UIImagePickerControllerOriginalImage] {
            let image:UIImage = originImage as! UIImage
            
            // 渡されてきた画像をフォトアルバムに保存
            //UIImageWriteToSavedPhotosAlbum(image, self, @selector(targetImage:didFinishSavingWithError:contextInfo:), NULL);
            
            //TODO 本来はpresenterに投げてそのコールバックを受けて、CollectionView に通知
            //TODO 確認用コード
            if images.count <= a {
                images.append([])
            }
            images[a].append(image)
            a ^= 1
            boardCollectionView.reloadData()
        }
    }
    
    /**
    画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
    
    - parameter picker: イメージ選択コントローラ
    */
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        // モーダルビューを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
        // キャンセルされたときの処理を記述・・・
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
    
}
