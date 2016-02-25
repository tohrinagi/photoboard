//
//  BoardInfoDataRepository.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/05.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボードヘッダ情報を操作するリポジトリクラス
class BoardInfoDataRepository: BoardInfoRepository {
    private let infoStore: BoardInfoDataStore
    private let infoMapper = BoardInfoMapper()
    
    private var boardInfoList = [BoardInfo]()
    
    init( infoStore: BoardInfoDataStore ) {
        self.infoStore = infoStore
    }
    
    /**
     BoardInfo を取得する処理
     
     - parameter completion: 処理完了ブロック
     */
    func read( completion: ([BoardInfo]) -> Void ) {
        infoStore.load { (entities) -> Void in
            self.boardInfoList = self.infoMapper.ToListModel(entities)
            self.save()
            completion(self.boardInfoList)
        }
    }
    
    /**
     BoardInfo を新規作成する処理
     
     - parameter completion: 処理完了ブロック
     */
    func create( completion: (BoardInfo) -> Void ) {
        infoStore.create { (info) -> Void in
            self.save()
            let model = self.infoMapper.ToModel(info)
            self.boardInfoList.append(model)
            completion(model)
        }
    }
    
    /**
     BoardInfo を更新する処理
     
     - parameter boardInfoList: 更新するモデル
     - parameter completion:    処理完了ブロック
     */
    func update( boardInfoList: [BoardInfo], completion : () -> Void ) {
        for boardInfo in boardInfoList {
            infoStore.search(boardInfo.id, completion: { (entity) -> Void in
                self.infoMapper.ToEntity(entity!, model: boardInfo)
            })
        }
        self.save()
        completion()
    }
    
    /**
     BoardInfo を削除する処理
     
     - parameter boardInfo: 削除するモデル
     - parameter completion:    処理更新ブロック
     */
    func delete( boardInfo: BoardInfo, completion : () -> Void ) {
        infoStore.delete(boardInfo.id) { () -> Void in
            //TODO BodyEntityとPhotoEntityも消えるか
            
            //TODO モデルも消す
            self.boardInfoList.removeAll()
            self.save()
            completion()
        }
    }
    
    /**
     保存処理
     */
    private func save() {
        CoreDataManager.sharedInstance.saveContext()
        afterSave()
    }
    
    /**
     セーブ後のエンティティとモデルのひも付け処理
     */
    private func afterSave() {
        //セーブ後にIDが変わるため、以前のIDと一致しているモデルに今回のIDをいれる
        boardInfoList.forEach { $0.id = infoStore.rebind($0.id) }
        //モデルにIDを渡したので、エンティティのprevioudISを正式なIDで上書き
        infoStore.updateID()
    }
}
