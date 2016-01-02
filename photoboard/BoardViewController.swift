//
//  BoardViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2015/12/31.
//  Copyright © 2015 tohrinagi. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

