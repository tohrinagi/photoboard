//
//  HomeViewModel.swift
//  photoboard
//
//  Created by tohrinagi on 2016/03/13.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import UIKit
import Photos

class HomeViewModel {
    private(set) var images: [UIImage]
    private(set) var boardInfoList = [BoardInfo]()
    
    init( infoList: [BoardInfo]) {
        self.boardInfoList = infoList
        self.images = []
    }
    
    /**
     セクションのアイテム数を返す
     - returns: アイテム数
     */
    func numberOfItems() -> Int {
        return images.count
    }
    
    /**
     イメージを取得する
     
     - parameter indexPath: IndexPath
     
     - returns: イメージ
     */
    func photo( indexPath: NSIndexPath) -> UIImage {
        return images[indexPath.row]
    }
    
    /**
     写真を移動する
     
     - parameter from: 元
     - parameter to:   先
     */
    func movePhoto(from: NSIndexPath, to: NSIndexPath) {
        let remove = images.removeAtIndex(from.row)
        images.insert(remove, atIndex: to.row)
    }
    
    /**
     すべての BoardInfo からImageを作る
     
     - parameter completion: 処理完了ブロック
     */
    func generateImageAll(completion: () -> Void) {
        images = []
        for info in boardInfoList {
            generateImage(info, completion: completion)
        }
    }
    
    /**
     BoardInfo から Imageを作る
     
     - parameter boardInfo:      InfoData
     - parameter completion: 処理完了ブロック
     */
    func generateImage( boardInfo: BoardInfo, completion: () -> Void) {
        if let headerPath = boardInfo.headerPath {
            
            let options = PHFetchOptions()
            options.includeHiddenAssets = true
            NSLog(headerPath)
            
            let fetchResult = headerPath.hasPrefix("assets-library") ?
                PHAsset.fetchAssetsWithALAssetURLs([NSURL(string: headerPath)!], options: options)
            : PHAsset.fetchAssetsWithLocalIdentifiers(
                [headerPath], options: options)
            
            //TODO ない
            let asset = fetchResult.firstObject as! PHAsset
            let targetSize = CGSize(width: 596, height: 100)
            let requestOption = PHImageRequestOptions()
            let realPhotoHeight = asset.pixelHeight * 100 / 596
            let headerRect = CGRect(x: 0, y: asset.pixelHeight/2 - realPhotoHeight/2,
                                    width: asset.pixelWidth,
                                    height: asset.pixelHeight/2 + realPhotoHeight/2)
            let cropRect = CGRectApplyAffineTransform(headerRect,
                                        CGAffineTransformMakeScale(
                                            1.0/CGFloat(asset.pixelWidth),
                                            1.0/CGFloat(asset.pixelHeight)) )
            requestOption.resizeMode = .Exact
            requestOption.normalizedCropRect = cropRect
            
            PHImageManager().requestImageForAsset(asset,
                targetSize: targetSize,
                contentMode: .AspectFill, options: requestOption) {
                    image, info in
                    
                    
                    while self.images.count <= boardInfo.row {
                        self.images.append(UIImage())
                    }
                    if let image = image {
                        self.images[ boardInfo.row ] = image
                    } else {
                        self.images[ boardInfo.row ] = UIImage()
                    }
                    completion()
            }
        } else {
            
            while self.images.count <= boardInfo.row {
                self.images.append(UIImage())
            }
            self.images[ boardInfo.row ] = UIImage()
        }
    }
}
