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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardPresenter.eventHandler = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.debugDescription)
    }
    
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
    // 画像が選択された時に呼ばれるデリゲートメソッド
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
    
    
    // 画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        // モーダルビューを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
        // キャンセルされたときの処理を記述・・・
    }
}

extension BoardViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = boardCollectionView.dequeueReusableCellWithReuseIdentifier("BoardCell", forIndexPath: indexPath) as! BoardCollectionViewCell
        
        cell.imageView.image = images[indexPath.section][indexPath.row]
        NSLog( String(indexPath.row) )
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images[section].count
    }
}

extension BoardViewController : BoardPresenterEventHandler {
    
}
