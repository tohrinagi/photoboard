//
//  BoardInfoListDataSource.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/01.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

class BoardInfoListDataStore: NSObject {
    
    func createEntity( completion : (BoardInfoEntity)->Void ) {
        let info = CoreDataManager.sharedInstance.create() as BoardInfoEntity
        let body = CoreDataManager.sharedInstance.create() as BoardBodyEntity
        info.body = body
        completion( info )
    }
    
    func readAllEntity( completion :(Bool,[BoardInfoEntity]?)->Void ) {
        let request = NSFetchRequest(entityName: "BoardInfoEntity")
        let result = CoreDataManager.sharedInstance.read(request) as [BoardInfoEntity]?
        completion( result != nil, result )
    }
    
    func updateEntity( entity : BoardInfoEntity, completion : (Bool)->Void ) {
        let success = CoreDataManager.sharedInstance.update()
        completion(success)
    }
    
    func deleteEntity( entity : BoardInfoEntity, completion : (Bool)->Void ) {
        let success  = CoreDataManager.sharedInstance.delete(entity)
        completion(success)
    }
}