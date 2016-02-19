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
    
    func create( info : BoardInfoEntity, completion : (BoardBodyEntity)->Void ) {
        let body = CoreDataManager.sharedInstance.create() as BoardBodyEntity
        info.body = body
        entities.add(body)
        completion( body )
    }
    
    func load( info :BoardInfoEntity, completion : (BoardBodyEntity?)->Void) {
        entities.add(info.body!)
        completion(info.body)
    }
    
    func search( id : String, completion : (BoardBodyEntity?)->Void ) {
        if let entity = entities.search(id) {
            completion(entity)
        } else {
            //TODO fetch ID
            completion(nil)
        }
    }
    
    func dispose( id : String ) {
        if let entity = entities.search(id) {
            CoreDataManager.sharedInstance.dispose(entity, mergeChanges: false)
            entities.remove(entity)
        }
    }
    
    func delete( id : String, completion : ()->Void ) {
        if let entity = entities.search(id) {
            CoreDataManager.sharedInstance.delete(entity)
            entities.remove(entity)
            completion()
        }else {
            //TODO 例外
            completion()
        }
    }
    
    func updateID() {
        entities.updateID()
    }
    
    func rebind(previousID : String) -> String {
        return entities.rebind( previousID)
    }
}