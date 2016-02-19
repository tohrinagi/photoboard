//
//  BoardDataBodyRepository.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/19.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボードヘッダ情報を操作するリポジトリクラス
class BoardBodyDataRepository : BoardBodyRepository {
    private let infoStore : BoardInfoDataStore
    private let bodyStore : BoardBodyDataStore
    private let photoStore : BoardPhotoDataStore
    
    private let infoMapper = BoardInfoMapper()
    private let bodyMapper = BoardBodyMapper()
    private let photoMapper = BoardPhotoMapper()
    
    private var boardBody : BoardBody? = nil
    
    init( infoStore : BoardInfoDataStore, bodyStore : BoardBodyDataStore, photoStore : BoardPhotoDataStore )
    {
        self.infoStore = infoStore
        self.bodyStore  = bodyStore
        self.photoStore = photoStore
    }
    
    /**
     BoardBody に Photo を追加する処理
     
     - parameter boardBody:    Photo を追加する BoardBody
     - parameter completion:   処理完了ブロック
     */
    func create(boardInfo: BoardInfo, completion: (BoardBody) -> Void) {
        infoStore.search(boardInfo.id) { (infoEntity) -> Void in //TODO search でfetchが必要
            self.bodyStore.create(infoEntity!, completion: { (bodyEntity) -> Void in
                self.boardBody = self.bodyMapper.ToModel(infoEntity!, bodyEntity: bodyEntity, photoEntities: [])
                self.save()
                completion(self.boardBody!)
            })
        }
    }
    
    /**
     BoardBody(Photo込で) を読み込む処理
     
     - parameter boardInfo:  BoardInfoモデル
     - parameter completion: 処理完了ブロック
     */
    func read( boardInfo : BoardInfo, completion : (BoardBody)->Void ) {
        infoStore.search(boardInfo.id) { (infoEntity) -> Void in
            self.bodyStore.load(infoEntity!, completion: { (bodyEntity) -> Void in
                self.photoStore.load(bodyEntity!, completion: { (photos) -> Void in
                    self.boardBody = self.bodyMapper.ToModel(infoEntity!, bodyEntity: bodyEntity!, photoEntities: photos)
                    completion(self.boardBody!)
                })
            })
        }
    }
    
    
    /**
     BoardBody の更新処理
     
     - parameter boardBody:  BoardBodyモデル
     - parameter completion: 処理完了ブロック
     */
    func update( boardBody : BoardBody, completion : ()->Void ) {
        infoStore.search(boardBody.info.id, completion: { (entity) -> Void in
            self.infoMapper.ToEntity(entity!, model: boardBody.info)
        })
        bodyStore.search(boardBody.id) { (entity) -> Void in
            self.bodyMapper.ToEntity(entity!, model: boardBody)
        }
        for photo in boardBody.photos {
            photoStore.search(photo.id, completion: { (entity) -> Void in
                self.photoMapper.ToEntity(entity!, model: photo)
            })
        }
        self.save()
    }
    
    /**
     Photo の作成
     
     - parameter boardBody:  追加するBodyモデル
     - parameter completion: 処理完了ブロック
     */
    func createPhoto( boardBody : BoardBody, completion : (BoardPhoto)->Void ) {
        bodyStore.search(boardBody.id) { (bodyEntity) -> Void in
            self.photoStore.create(bodyEntity!, completion: { (photoEntity) -> Void in
                let photoModel = self.photoMapper.ToModel(photoEntity)
                boardBody.AddPhoto(photoModel)
                completion(photoModel)
            })
        }
    }
    
    /**
     Photo の削除
     
     - parameter boardPhoto: 削除元のBodyモデル
     - parameter completion: 処理完了ブロック
     */
    func deletePhoto( boardPhoto : BoardPhoto, completion : ()->Void ) {
        if let body = self.boardBody {
            body.deletePhoto(boardPhoto)
            photoStore.delete(boardPhoto.id, completion: { () -> Void in
                self.save()
                completion()
            })
        } else {
            completion()
        }
    }
    
    /**
     保存処理
     */
    private func save(){
        CoreDataManager.sharedInstance.saveContext()
        afterSave()
    }
    
    /**
     セーブ後のエンティティとモデルのひも付け処理
     */
    private func afterSave() {
        if let body = self.boardBody {
            //セーブ後にIDが変わるため、以前のIDと一致しているモデルに今回のIDをいれる
            body.info.id = infoStore.rebind(body.info.id)
            body.id = bodyStore.rebind(body.id)
            body.photos.forEach{ $0.id = photoStore.rebind($0.id) }
            //モデルにIDを渡したので、エンティティのprevioudISを正式なIDで上書き
            infoStore.updateID()
            bodyStore.updateID()
            photoStore.updateID()
        }
    }
}