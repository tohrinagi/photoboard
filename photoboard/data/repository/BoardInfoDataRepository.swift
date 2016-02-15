//
//  BoardDataRepository.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/05.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボード情報を操作するリポジトリクラス
class BoardInfoDataRepository : BoardInfoRepository {
    private let infoDataSource = BoardInfoListDataStore()
    private let bodyDataSource = BoardBodyDataSource()
    private let infoMapper = BoardInfoMapper()
    private let bodyMapper = BoardBodyMapper()
    private let photoMapper = BoardPhotoMapper()
    
    private var boardInfoEntities : [BoardInfoEntity]? = nil
    private var boardInfoList : BoardInfoList? = nil
    
    /**
     BoardInfoList を取得する処理
     
     - parameter completion: 処理完了ブロック
     */
    func readBoardInfoList( completion : (BoardInfoList)->Void ) {
        infoDataSource.readAllEntity {
            ( success, boardInfoEntities ) -> Void in
            if success {
                self.boardInfoEntities = boardInfoEntities
            } else {
                self.boardInfoEntities = []
            }
            self.boardInfoList = self.infoMapper.ToListModel(boardInfoEntities!)
            completion(self.boardInfoList!)
        }
    }
    
    /**
     BoardInfoList を更新する処理
     
     - parameter boardInfoList: 更新するモデル
     - parameter completion:    処理完了ブロック
     */
    func updateBoardInfoList( boardInfoList : BoardInfoList, completion : (Bool)->Void ) {
        for boardInfo in boardInfoList.items {
            if let entity = searchEntity(boardInfo) {
                infoMapper.ToEntity(entity, info: boardInfo)
                infoDataSource.updateEntity(entity, completion: { (success) -> Void in
                    if success {
                        self.afterSave()
                    }
                    completion(success)
                })
            } else {
                completion(false)
            }
        }
    }
    
    /**
     BoardInfo を削除する処理
     
     - parameter boardInfo:  削除するモデル
     - parameter completion: 処理完了ブロック
     */
    func deleteBoardInfoList( boardInfo : BoardInfo, completion : (Bool)->Void ) {
        if let entity = searchEntity(boardInfo) {
            infoDataSource.deleteEntity(entity) { (success) -> Void in
                if success {
                    self.afterSave()
                }
                completion(success)
            }
        } else {
            completion(false)
        }
    }
    
    /**
     BoardInfo を新規作成する処理
     
     - parameter completion: 処理完了ブロック
     */
    func createNewBoard( completion : (BoardInfo)->Void ) {
        infoDataSource.createEntity { (boardInfoEntity) -> Void in
            self.boardInfoEntities?.append(boardInfoEntity)
            //TODO InfoListにいれる？？
            self.afterSave()
            completion(self.infoMapper.ToModel(boardInfoEntity))
        }
    }
    
    /**
     BoardBody を読み込む処理
     
     - parameter boardInfo:  BoardInfoモデル
     - parameter completion: 処理完了ブロック
     */
    func readBoardBody( boardInfo : BoardInfo, completion : (Bool,BoardBody?)->Void ) {
        if let infoEntity = searchEntity(boardInfo) {
            completion(true, bodyMapper.ToModel(infoEntity) )
        }else {
            completion(false, nil)
        }
    }
    
    /**
     BoardBody に Photo を追加する処理
     
     - parameter boardBody:    Photo を追加する BoardBody
     - parameter referenceUrl: 画像の参照URL
     - parameter section:      セクション位置
     - parameter row:          ROW位置
     - parameter completion:   処理完了ブロック
     */
    func addBoardPhoto( boardBody : BoardBody, referenceUrl : String, section : Int, row : Int, completion : (BoardPhoto)->Void ) {
        if let infoEntity = searchEntity(boardBody.info) {
            //infoEntity.body?.photos
            bodyDataSource.createEntity(infoEntity.body!, completion: { (boardPhotoEntity) -> Void in
                boardPhotoEntity.name = referenceUrl
                boardPhotoEntity.section = section
                boardPhotoEntity.row = row
                self.bodyDataSource.updateEntity( { (success) -> Void in
                    self.afterSave()
                    completion(self.photoMapper.ToModel(boardPhotoEntity))
                })
            })
        }
    }
    
    /**
     BoardPhoto の入れ替え処理
     
     - parameter boardBody:  Photo を移動する BoardBody
     - parameter from:       移動元写真
     - parameter to:         移動後写真
     - parameter completion: 処理完了ブロック
     */
    func moveBoardPhoto(boardBody: BoardBody, from: NSIndexPath, to: NSIndexPath, completion: (from: BoardPhoto, to: BoardPhoto) -> Void) {
        //TODO
        //let sourceImage = images[sourceIndexPath.section].removeAtIndex(sourceIndexPath.row)
        //images[destinationIndexPath.section].insert(sourceImage, atIndex: destinationIndexPath.row)
    }
    
    /**
     BoardInfo から BoardInfoEntity を取得する処理
     
     - parameter model: BoardInfoモデル
     
     - returns: BoardInfoEntityモデル
     */
    private func searchEntity( model : BoardInfo) -> BoardInfoEntity? {
        return boardInfoEntities?.filter{ $0.id == model.id }.first
    }
    
    /**
     セーブ後のエンティティとモデルのひも付け処理
     */
    private func afterSave() {
        //セーブ後にIDが変わるため、以前のIDと一致しているモデルに今回のIDをいれる
        boardInfoList?.items.forEach{ item in
            let entities = boardInfoEntities?.filter{ $0.previousID == item.id }
            if let entity = entities?.first {
                item.id = entity.id
                NSLog("after save : \(item.id)")
            }
        }
        //モデルにIDを渡したので、エンティティのprevioudISを正式なIDで上書き
        boardInfoEntities?.forEach{ $0.updatePrevioudId() }
    }
}