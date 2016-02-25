//
//  CoreDataStore.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/17.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStore<T:CoreDataEntity> {
    
    private var entities = [T]()
    
    func add( entity: T ) {
        entities.append(entity)
    }
    
    func overwrite( entities: [T] ) {
        self.entities = entities
    }
    
    func search( id: String ) -> T? {
        return entities.filter({$0.id == id}).first
    }
    
    func searchAll() -> [T] {
        return entities
    }
    
    func remove( entity: T) {
        if let index = entities.indexOf(entity) {
            entities.removeAtIndex(index)
        }
    }
    
    func clear() {
        entities.removeAll()
    }
    
    func updateID() {
        entities.forEach { $0.updatePrevioudId() }
    }
    
    func rebind( previousID: String ) -> String {
        let result = entities.filter { $0.previousID == previousID }
        return (result.first?.id)!
    }
}
