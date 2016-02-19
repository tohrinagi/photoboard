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
    
    func create( body : BoardBodyEntity, completion : (BoardPhotoEntity)->Void ) {
        let photo = CoreDataManager.sharedInstance.create() as BoardPhotoEntity
        body.addPhoto(photo)
        entities.add(photo)
        completion(photo)
    }
    
    func load( body : BoardBodyEntity, completion : ([BoardPhotoEntity])->Void ) {
        entities.clear()
        for item in body.photos! {
            if let photo = item as? BoardPhotoEntity {
                entities.add(photo)
            }
        }
        completion(entities.searchAll())
    }
    
    func search( id : String, completion : (BoardPhotoEntity?)->Void ) {
        if let entity = entities.search(id) {
            completion(entity)
        } else {
            //TODO 例外
            completion(nil)
        }
    }
    
    func dispose() {
        for entity in entities.searchAll() {
            CoreDataManager.sharedInstance.dispose(entity, mergeChanges: false)
        }
        entities.clear()
    }
    
    func delete( id : String, completion : ()->Void ) {
        if let entity = entities.search(id) {
            CoreDataManager.sharedInstance.delete(entity)
            entities.remove(entity)
            completion()
        }else {
            //TODO例外
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