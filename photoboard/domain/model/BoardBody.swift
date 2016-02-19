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
    var id : String
    
    init( id : String, info : BoardInfo, photos : [BoardPhoto] ) {
        self.id = id
        self.info = info
        self.photos = photos
        super.init()
    }
    
    func AddPhoto( photo : BoardPhoto )
    {
        photos.append(photo)
    }
    
    func deletePhoto( photo : BoardPhoto )
    {
        photos.removeAtIndex(photos.indexOf(photo)!)
    }
}