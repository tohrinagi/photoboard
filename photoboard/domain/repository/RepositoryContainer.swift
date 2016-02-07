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
    class var sharedInstance : RepositoryContainer {
        struct Static {
            static let instance = RepositoryContainer()
        }
        return Static.instance
    }
    private(set) var boardInfoRepository : BoardInfoRepository
    
    
    init() {
        //TODO DI する
        self.boardInfoRepository = BoardInfoDataRepository()
    }
}