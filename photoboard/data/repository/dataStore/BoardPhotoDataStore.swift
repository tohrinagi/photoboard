//
//  BoardPhotoDataStore.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/18.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

class BoardPhotoDataStore {

    private var entities = CoreDataStore<BoardPhotoEntity>()
    
    /**
     BoardPhotoEntity を新規作成する
     
     - parameter body:       関連付ける Body
     - parameter completion: 処理完了ブロック
     */
    func create( body: BoardBodyEntity, completion: (BoardPhotoEntity) -> Void ) {
        do {
            let photo = try CoreDataManager.sharedInstance.create() as BoardPhotoEntity
            body.addPhoto(photo)
            entities.add(photo)
            completion(photo)
        } catch {
            assert(false)
        }
    }
    
    /**
     BoardPhotoEntity を読み込む
     
     - parameter body:       関連付けていた Body
     - parameter completion: 処理完了ブロック
     */
    func load( body: BoardBodyEntity, completion: ([BoardPhotoEntity]) -> Void ) {
        entities.clear()
        if let photos = body.photos {
            for item in photos {
                if let photo = item as? BoardPhotoEntity {
                    entities.add(photo)
                }
            }
            completion(entities.searchAll())
        } else {
            assert(false)
        }
    }
    
    /**
     キャッシュ上にあるBoardPhotoEntityを検索し返す
     
     - parameter id:         検索するID
     - parameter completion: 処理完了ブロック
     */
    func search( id: String, completion: (BoardPhotoEntity) -> Void ) {
        if let entity = entities.search(id) {
            completion(entity)
        } else {
            assert(false)
        }
    }
    
    /**
     BoardPhotoEntity をすべて処分
     */
    func dispose() {
        for entity in entities.searchAll() {
            CoreDataManager.sharedInstance.dispose(entity, mergeChanges: false)
        }
        entities.clear()
    }
    
    /**
     BoardPhotoEntity を消去
     
     - parameter id:         消去する ID
     - parameter completion: 処理完了ブロック
     */
    func delete( id: String, completion : () -> Void ) {
        if let entity = entities.search(id) {
            CoreDataManager.sharedInstance.delete(entity)
            entities.remove(entity)
            completion()
        } else {
            assert(false)
        }
    }
    
    /**
     Entity の IDを更新する
     */
    func updateID() {
        entities.updateID()
    }
    
    /**
     古いIDをもとに新しいIDを返す
     
     - parameter previousID: 古いID
     
     - returns: 新しいID
     */
    func rebind(previousID: String) -> String {
        return entities.rebind( previousID)
    }
}
