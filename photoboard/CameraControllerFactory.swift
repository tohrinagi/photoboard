//
//  CameraControllerFactory.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import UIKit

class CameraControllerFactory {
    
    // カメラが使用可能か調べる
    class func isAvailable() -> Bool {
        if( !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) ){
            return true
        }
        return false
    }

    class func Generate() -> UIImagePickerController {
        // UIImagePickerControllerのインスタンスを生成
        let imagePickerController = UIImagePickerController()
        
        // 画像の取得先をカメラに設定
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // 画像取得後に編集するかどうか（デフォルトはNO）
        imagePickerController.allowsEditing = false
     
        return imagePickerController
    }

}