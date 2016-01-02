//
//  BoardViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2015/12/31.
//  Copyright © 2015 tohrinagi. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBAction func cameraTouchUpInsideHandler(sender: AnyObject) {
        showUIImagePicker();
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showUIImagePicker() {
        // カメラが使用可能かどうか判定する
        if( !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) ){
            return
        }
        
        // UIImagePickerControllerのインスタンスを生成
        let imagePickerController = UIImagePickerController()
        
        // デリゲートを設定
        imagePickerController.delegate = self
        
        // 画像の取得先をカメラに設定
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // 画像取得後に編集するかどうか（デフォルトはNO）
        imagePickerController.allowsEditing = false
        
        // 撮影画面をモーダルビューとして表示する
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }

    // 画像が選択された時に呼ばれるデリゲートメソッド
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        // モーダルビューを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    
        // 渡されてきた画像をフォトアルバムに保存
      //  UIImageWriteToSavedPhotosAlbum(image, self, @selector(t), <#T##contextInfo: UnsafeMutablePointer<Void>##UnsafeMutablePointer<Void>#>)
        //UIImageWriteToSavedPhotosAlbum(image, self, @selector(targetImage:didFinishSavingWithError:contextInfo:), NULL);
    }

    // 画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        // モーダルビューを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
        // キャンセルされたときの処理を記述・・・
    }
    
}

