//
//  BoardInfoDataRepository.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/05.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

class BoardInfoDataRepository : BoardInfoRepository {
    private let dataSource = BoardInfoListDataStore()
    private let mapper = BoardInfoMapper()
    
    /**
     BoardInfoList を取得する処理
     
     - parameter completion: 処理完了ブロック
     */
    func getBoardInfoList( completion : (BoardInfoList)->Void ) {
        dataSource.readAllEntity {
            ( success, boardInfoEntities ) -> Void in
            if success {
                completion( self.mapper.ToListModel(boardInfoEntities!) )
            } else {
                completion( self.mapper.ToListModel([]))
            }
        }
    }
    
    func updateBoardInfoList( boardInfoList : BoardInfoList, completion : (Bool)->Void ) {
        //TODO
        completion(true)
    }
}