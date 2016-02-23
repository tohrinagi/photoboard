//
//  BoardPhotoMapper.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/11.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

class BoardPhotoMapper {
    func ToModel( entity : BoardPhotoEntity ) -> BoardPhoto {
        return BoardPhoto(id: entity.id, photoPath: entity.name!, section: Int(entity.section!), row: Int(entity.row!))
    }
    
    func ToNewModel( entity : BoardPhotoEntity ) -> BoardPhoto {
        return BoardPhoto(id: entity.id)
    }
    
    func ToListModel( entities : [BoardPhotoEntity] ) -> [BoardPhoto] {
        var list = [BoardPhoto]()
        for entity in entities {
            list.append(ToModel(entity))
        }
        return list
    }
    
    func ToEntity( entity : BoardPhotoEntity, model :BoardPhoto ) {
        entity.name = model.photoPath
        entity.row = model.row
        entity.section = model.section
    }
    
    func ToListEntity( entities : [BoardPhotoEntity], models : [BoardPhoto] ) {
        for entity in entities {
            if let model = models.filter({$0.id == entity.id}).first {
                ToEntity(entity, model: model)
            }
            else
            {
                assert(false)
            }
        }
    }
}