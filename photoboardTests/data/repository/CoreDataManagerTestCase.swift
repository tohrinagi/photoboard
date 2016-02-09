//
//  CoreDataManagerTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/09.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
import CoreData
@testable import photoboard

class CoreDataManagerTestCase: XCTestCase {
    func testCreate() {
        let entity : BoardInfoEntity = CoreDataManager.sharedInstance.create()
        XCTAssertNotNil(entity)
    }

    func testRead() {
        let entityName = NSStringFromClass(BoardInfoEntity).componentsSeparatedByString(".").last! as String
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let entities : [BoardInfoEntity]? = CoreDataManager.sharedInstance.read(fetchRequest)
        XCTAssertNotNil(entities)
    }
    
    func testUpdate() {
        CoreDataManager.sharedInstance.update()
    }
    
    func testDelete() {
        let entity : BoardInfoEntity = CoreDataManager.sharedInstance.create()
        CoreDataManager.sharedInstance.delete(entity)
    }

    func testCombination() {
        deleteAll()
        
        let title = "testTitle"
        
        let createdEntity : BoardInfoEntity = CoreDataManager.sharedInstance.create()
        createdEntity.title = title
        let updateResult = CoreDataManager.sharedInstance.update()
        XCTAssert(updateResult)
        
        let entityName = NSStringFromClass(BoardInfoEntity).componentsSeparatedByString(".").last! as String
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let readEntities : [BoardInfoEntity]? = CoreDataManager.sharedInstance.read(fetchRequest)
        XCTAssertNotNil(readEntities)
        XCTAssertEqual(readEntities!.count, 1)
        XCTAssertEqual(readEntities!.first!.title, title)
        
        CoreDataManager.sharedInstance.delete(readEntities!.first!)
        
        let reloadedEntities : [BoardInfoEntity]? = CoreDataManager.sharedInstance.read(fetchRequest)
        XCTAssert( reloadedEntities == nil || reloadedEntities?.count == 0 )
    }
    
    
    func deleteAll() {
        let entityName = NSStringFromClass(BoardInfoEntity).componentsSeparatedByString(".").last! as String
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let readEntities : [BoardInfoEntity]? = CoreDataManager.sharedInstance.read(fetchRequest)
        if let readEntities = readEntities {
            for entity in readEntities {
                CoreDataManager.sharedInstance.delete(entity)
            }
        }
    }

}
