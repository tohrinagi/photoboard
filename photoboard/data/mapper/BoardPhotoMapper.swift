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
        return BoardPhoto(photoPath: entity.name!, section: Int(entity.section!), row: Int(entity.row!))
    }
}