//
//  RepositoryContainer.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/06.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// Repository 保持クラス
class RepositoryContainer {
    class var sharedInstance: RepositoryContainer {
        struct Static {
            static let instance = RepositoryContainer()
        }
        return Static.instance
    }
    private(set) var boardInfoRepository: BoardInfoRepository
    private(set) var boardBodyRepository: BoardBodyRepository
    
    //以下依存
    private var infoDataStore = BoardInfoDataStore()
    private var bodyDataStore = BoardBodyDataStore()
    private var photoDataStore = BoardPhotoDataStore()
    
    
    init() {
        self.boardInfoRepository = BoardInfoDataRepository( infoStore: self.infoDataStore )
        self.boardBodyRepository = BoardBodyDataRepository(
            infoStore: self.infoDataStore,
            bodyStore: self.bodyDataStore,
            photoStore: self.photoDataStore )
    }
}
