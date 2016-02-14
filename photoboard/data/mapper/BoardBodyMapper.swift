//
//  BoardBodyMapper.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/11.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

class BoardBodyMapper {
    let infoMapper = BoardInfoMapper()
    let photoMapper = BoardPhotoMapper()

    func ToModel( entity : BoardInfoEntity ) -> BoardBody {
        var photos = [BoardPhoto]()
        for item in entity.body?.photos ?? [] {
            let photo = item as! BoardPhotoEntity
            photos.append( photoMapper.ToModel(photo) )
        }
        
        return BoardBody(info: infoMapper.ToModel(entity), photos: photos )
    }
}