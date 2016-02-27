//
//  BoardInfoListDataSource.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/01.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

class BoardInfoDataStore: NSObject {
    
    private var entities = CoreDataStore<BoardInfoEntity>()
    
    /**
     BoardInfoEntity を新規作成する
     
     - parameter completion: 処理完了ブロック
     */
    func create( completion: (BoardInfoEntity) -> Void ) {
        do {
            let info = try CoreDataManager.sharedInstance.create() as BoardInfoEntity
            entities.add(info)
            completion(info)
        } catch {
            assert(false)
        }
    }
    
    /**
     BoardInfoEntity をストレージから読み込む(現在のキャッシュはクリアされる)
     
     - parameter completion: 処理完了ブロック
     */
    func load( completion: ([BoardInfoEntity]) -> Void ) {
        entities.clear()
        let request = NSFetchRequest(entityName: "BoardInfoEntity")
        do {
            let result = try CoreDataManager.sharedInstance.read(request) as [BoardInfoEntity]
            entities.overwrite(result)
            completion( entities.searchAll() )
        } catch {
            assert(false)
        }
    }
    
    /**
     キャッシュ上にある Info を検索
     
     - parameter id:         探す Info の ID
     - parameter completion: 処理完了ブロック
     */
    func search( id: String, completion: (BoardInfoEntity) -> Void ) {
        if let entity = entities.search(id) {
            completion(entity)
        } else {
            assert(false)
        }
    }
    
    /**
     BoardInfoEntityを削除
     
     - parameter id:         削除するEntityのID
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
