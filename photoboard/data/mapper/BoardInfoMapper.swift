//
//  BoardInfoMapper.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/05.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// BoardInfo 用 Entity から Model に変換するクラス
class BoardInfoMapper: NSObject {
    
    /**
     BoardInfoEntity から BoardInfo への変換
     
     - parameter info: entity
     
     - returns: model
     */
    func ToModel( info: BoardInfoEntity ) -> BoardInfo {
        return BoardInfo(id: info.id, title: info.title,
            headerPath: info.headerPath, row: Int(info.row!),
            createdAt: info.createdAt!, updatedAt: info.updatedAt!)
    }
    
    /**
     BoardInfoEntyty 配列から BoardInfoList への変換
     
     - parameter infos: entity の配列
     
     - returns: model
     */
    func ToListModel( infos: [BoardInfoEntity] ) -> [BoardInfo] {
        var list: [BoardInfo] = []
        for info in infos {
            list.append(ToModel(info))
        }
        return list
    }
    
    /**
     Modelの内容をEntityへ書き出し
     
     - parameter entity: BoardInfoEntity
     - parameter model:  BoardInfo
     */
    func ToEntity( entity: BoardInfoEntity, model: BoardInfo ) {
        entity.createdAt = model.createdAt
        entity.headerPath = model.headerPath
        entity.row = model.row
        entity.title = model.title
        entity.updatedAt = model.updatedAt
    }
}
