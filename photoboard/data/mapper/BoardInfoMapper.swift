//
//  BoardInfoMapper.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/05.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// BoardInfo 用 Entity から Model に変換するクラス
class BoardInfoMapper : NSObject {
    
    /**
     BoardInfoEntity から BoardInfo への変換
     
     - parameter info: entity
     
     - returns: model
     */
    func ToModel( info : BoardInfoEntity ) -> BoardInfo {
        return BoardInfo(id: info.id, title: info.title!, row: info.row!, createdAt: info.createdAt!, updatedAt: info.updatedAt!)
    }
    
    /**
     BoardInfoEntyty 配列から BoardInfoList への変換
     
     - parameter infos: entity の配列
     
     - returns: model
     */
    func ToListModel( infos : [BoardInfoEntity] ) -> BoardInfoList {
        var list : [BoardInfo] = []
        for info in infos {
            list.append(ToModel(info))
        }
        return BoardInfoList(boardInfos: list)
    }
    
    
    func ToEntity( entity : BoardInfoEntity, info : BoardInfo ){
        NSLog("\(entity.objectID.URIRepresentation())=\(info.id)")
        if entity.objectID.URIRepresentation().absoluteString != info.id {
            assert(false)
        }
        entity.row = info.row
        entity.title = info.title
        entity.updatedAt = info.updatedAt
        entity.createdAt = info.createdAt
    }
}