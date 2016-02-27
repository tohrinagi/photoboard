//
//  BoardBodyDataStore.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/14.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

class BoardBodyDataStore {
    
    private var entities = CoreDataStore<BoardBodyEntity>()
    
    /**
     BoardBodyEntity を新規作成する
     
     - parameter info:       Body に関連させる BoardInfoEntity
     - parameter completion: 処理完了ブロック
     */
    func create( info: BoardInfoEntity, completion: (BoardBodyEntity) -> Void ) {
        do {
            let body = try CoreDataManager.sharedInstance.create() as BoardBodyEntity
            info.body = body
            entities.add(body)
            completion(body)
        } catch {
            assert(false)
        }
    }
    
    /**
     BoardBodyEntity を読み込む
     
     - parameter info:       読み込む Body に関連んした Info
     - parameter completion: 処理完了ブロック
     */
    func load( info: BoardInfoEntity, completion: (BoardBodyEntity) -> Void) {
        entities.clear()
        if let body = info.body {
            entities.add(body)
            completion(body)
        } else {
            assert(false)
        }
    }
    
    /**
     キャッシュ上にあるBoardBodyEntityを検索し返す
     
     - parameter id:         探すID
     - parameter completion: 処理完了ブロック
     */
    func search( id: String, completion: (BoardBodyEntity) -> Void ) {
        if let entity = entities.search(id) {
            completion(entity)
        } else {
            assert(false)
        }
    }
    
    /**
     BoardBodyEntity を処分
     
     - parameter id: 処分するID
     */
    func dispose( id: String ) {
        if let entity = entities.search(id) {
            CoreDataManager.sharedInstance.dispose(entity, mergeChanges: false)
            entities.remove(entity)
        }
    }
    
    /**
     BoardBodyEntity を消去
     
     - parameter id:         消去するID
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
