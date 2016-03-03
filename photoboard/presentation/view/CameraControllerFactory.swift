//
//  CameraControllerFactory.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import UIKit

class CameraControllerFactory {
    
    /**
    カメラが使用可能が調べる
    
    - parameter sourceType: ソースタイプ

    - returns: trueで使用可能、falseで不可
    */
    class func isAvailable(sourceType: UIImagePickerControllerSourceType) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            return true
        }
        return false
    }

    /**
     UiImagePickerController を設定して返す
     
     - parameter sourceType: ソースタイプ
     
     - returns: UIImagePickerController
     */
    class func Generate(sourceType: UIImagePickerControllerSourceType) -> UIImagePickerController {
        // UIImagePickerControllerのインスタンスを生成
        let imagePickerController = UIImagePickerController()
        
        // 画像の取得先をカメラに設定
        imagePickerController.sourceType = sourceType
        
        // 画像取得後に編集するかどうか（デフォルトはNO）
        imagePickerController.allowsEditing = false
     
        return imagePickerController
    }

}
