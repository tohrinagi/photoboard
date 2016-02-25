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

    func ToModel( infoEntity: BoardInfoEntity, bodyEntity: BoardBodyEntity,
        photoEntities: [BoardPhotoEntity] ) -> BoardBody {
        
        return BoardBody(id: bodyEntity.id, info: infoMapper.ToModel(infoEntity),
            photos: photoMapper.ToListModel(photoEntities) )
    }
    
    
    func ToEntity( entity: BoardBodyEntity, model: BoardBody ) {
        //処理なし
    }
}
