//
//  BoardBodyViewModel.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/21.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import UIKit
import Photos

/// BoardBody の View処理追加版
class BoardBodyViewModel {
    
    private let boardBody : BoardBody
    private var images : [[UIImage]]

    init( boardBody:BoardBody)
    {
        self.boardBody = boardBody
        self.images = []
    }
    
    /**
     セクション数を返す
     
     - returns: セクション数
     */
    func numberOfSections() -> Int
    {
        return images.count
    }
    
    /**
     セクションのアイテム数を返す
     
     - parameter section: どのセクションか
     
     - returns: アイテム数
     */
    func numberOfItems( section : Int ) -> Int
    {
        if section < images.count {
            return images[section].count
        } else {
            return 0
        }
    }
    
    /**
     イメージを取得する
     
     - parameter indexPath: IndexPath
     
     - returns: イメージ
     */
    func photo( indexPath : NSIndexPath) -> UIImage
    {
        return images[indexPath.section][indexPath.row]
    }
    
    /**
     セクションの数に応じて、ドラッグ用のセクションを追加、削除する
     */
    func updateBlankSection()
    {
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
    }
    
    /**
     写真を移動する
     
     - parameter fromPhoto: 元
     - parameter toPhoto:   先
     */
    func movePhoto(from: NSIndexPath, to: NSIndexPath)
    {
        let remove = images[from.section].removeAtIndex(from.row)
        images[to.section].insert(remove, atIndex: to.row)
    }
    
    /**
     すべての BoardPhoto からImageを作る
     
     - parameter completion: 処理完了ブロック
     */
    func generateImageAll(completion: ()->Void)
    {
        for photo in boardBody.photos {
            generateImage(photo, completion: {
                completion()
            })
        }
    }
    
    /**
     BoardPhoto から Imageを作る
     
     - parameter photo:      Photo
     - parameter completion: 処理完了ブロック
     */
    func generateImage(photo:BoardPhoto, completion: ()->Void)
    {
        let options = PHFetchOptions()
        options.includeHiddenAssets = true
        NSLog(photo.referenceURL.absoluteString)
        let fetchResult = PHAsset.fetchAssetsWithALAssetURLs([photo.referenceURL], options: options)
        let asset = fetchResult.firstObject as! PHAsset
     
        PHImageManager().requestImageForAsset(asset,
            targetSize: CGSize(width: 320, height: 320),
            contentMode: .AspectFill, options: nil) {
                image, info in
                
                while self.images.count <= photo.section {
                    self.images.append([])
                }
                while self.images[photo.section].count <= photo.row {
                    self.images[photo.section].append(UIImage())
                }
                self.images[photo.section][photo.row] = image!
                completion()
        }
    }
    
}