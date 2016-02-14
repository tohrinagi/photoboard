//
//  BoardBody.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/31.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// １つのphotoboard
class BoardBody : NSObject {
    let info : BoardInfo
    private(set) var photos : [BoardPhoto]
    
    init( info : BoardInfo, photos : [BoardPhoto] ) {
        self.info = info
        self.photos = photos
        super.init()
    }
}