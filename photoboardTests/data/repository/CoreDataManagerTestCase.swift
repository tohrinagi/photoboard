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
        do {
            let entity: BoardInfoEntity = try CoreDataManager.sharedInstance.create()
            XCTAssertNotNil(entity)
        } catch {
            XCTAssert(false)
        }
    }

    func testRead() {
        let entityName = NSStringFromClass(BoardInfoEntity)
            .componentsSeparatedByString(".").last! as String
        let fetchRequest = NSFetchRequest(entityName: entityName)
        do {
            let entities: [BoardInfoEntity]? = try CoreDataManager
                .sharedInstance.read(fetchRequest)
            XCTAssertNotNil(entities)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testDelete() {
        do {
            let entity: BoardInfoEntity = try CoreDataManager
                .sharedInstance.create()
            CoreDataManager.sharedInstance.delete(entity)
        } catch {
            XCTAssert(false)
        }
    }

    func testCombination() {
        deleteAll()
        
        let title = "testTitle"
        
        do {
            let createdEntity: BoardInfoEntity = try CoreDataManager
                .sharedInstance.create()
            createdEntity.title = title
        } catch {
            XCTAssert(false)
        }
        
        let entityName = NSStringFromClass(BoardInfoEntity)
            .componentsSeparatedByString(".").last! as String
        let fetchRequest = NSFetchRequest(entityName: entityName)
        do {
            let readEntities: [BoardInfoEntity]? = try CoreDataManager
                .sharedInstance.read(fetchRequest)
            XCTAssertNotNil(readEntities)
            XCTAssertEqual(readEntities!.count, 1)
            XCTAssertEqual(readEntities!.first!.title, title)
            CoreDataManager.sharedInstance.delete(readEntities!.first!)
        } catch {
            XCTAssert(false)
        }
        
        do {
            let reloadedEntities: [BoardInfoEntity]? = try CoreDataManager
                .sharedInstance.read(fetchRequest)
            XCTAssert( reloadedEntities == nil || reloadedEntities?.count == 0 )
        } catch {
            XCTAssert(false)
        }
    }
    
    
    func deleteAll() {
        DataStoreUtil().deleteAllEntities()
    }

}
