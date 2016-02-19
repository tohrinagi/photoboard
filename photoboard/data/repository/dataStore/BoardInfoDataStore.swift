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
    
    func create( completion : (BoardInfoEntity)->Void ) {
        let info = CoreDataManager.sharedInstance.create() as BoardInfoEntity
        entities.add(info)
        completion( info )
    }
    
    func load( completion :([BoardInfoEntity])->Void ) {
        entities.clear()
        let request = NSFetchRequest(entityName: "BoardInfoEntity")
        if let result = CoreDataManager.sharedInstance.read(request) as [BoardInfoEntity]? {
            entities.overwrite(result)
            completion( entities.searchAll() )
        }else{
            //TODO 例外
        }
    }
    
    func search( id : String, completion : (BoardInfoEntity?)->Void ) {
        if let entity = entities.search(id) {
            completion(entity)
        } else {
            //TODO fetch id 
            completion(nil)
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