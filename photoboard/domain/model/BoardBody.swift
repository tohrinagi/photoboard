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
    
    func photo( indexPath : NSIndexPath ) -> BoardPhoto
    {
        return photos.filter{$0.indexPath == indexPath }.first!
    }
    
    func addPhoto( photo : BoardPhoto )
    {
        photos.append(photo)
    }
    
    func deletePhoto( photo : BoardPhoto )
    {
        photos.removeAtIndex(photos.indexOf(photo)!)
    }
    
    func movePhoto( from : NSIndexPath, to : NSIndexPath )
    {
        let remove = photos.filter{$0.indexPath == from}.first!
        //remove
        photos.filter{$0.section == from.section && $0.row >= from.row }.forEach{$0.row-=1 }
        //add
        photos.filter{$0.section == to.section && $0.row >= to.row}.forEach{$0.row+=1 }
        
        remove.section = to.section
        remove.row = to.row
    }
}