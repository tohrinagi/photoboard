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
    
    override init() {
        self.info = BoardInfo()
        self.photos = []
        super.init()
    }

    func createNewPhoto( path : String ) -> BoardPhoto {
        return BoardPhoto(photoPath: "")
    }
    
    func deletePhoto( photo : BoardPhoto ) {
        
    }
    
    func movePhoto( movedPhoto : BoardPhoto, insertAt : Int ) {
        
    }
}