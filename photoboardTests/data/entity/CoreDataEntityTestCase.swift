//
//  CoreDataEntityTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/24.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
import CoreData
@testable import photoboard

class CoreDataEntityTestCase: XCTestCase {
    //CoreDataEntity は テストできないので、BoardInfoEntity にて代用する
    override func setUp() {
        let fetchRequest = NSFetchRequest(entityName: "BoardInfoEntity")
        let readEntities : [BoardInfoEntity]? = CoreDataManager.sharedInstance.read(fetchRequest)
        if let readEntities = readEntities {
            for entity in readEntities {
                CoreDataManager.sharedInstance.delete(entity)
            }
        }
    }
    
    func testCreate() {
        let entity = CoreDataManager.sharedInstance.create() as BoardInfoEntity
        XCTAssertNotNil(entity)
        XCTAssertNotNil(entity.previousID)
        XCTAssertNotEqual(entity.previousID, "")
    }
    
    func testFetch() {
        CoreDataManager.sharedInstance.create() as BoardInfoEntity
        CoreDataManager.sharedInstance.saveContext()
        
        let fetchRequest = NSFetchRequest(entityName: "BoardInfoEntity")
        let entities = CoreDataManager.sharedInstance.read(fetchRequest) as [BoardInfoEntity]?
        XCTAssertNotNil(entities)
        XCTAssertEqual(entities?.count, 1)
        XCTAssertNotNil(entities?.first!.previousID)
        XCTAssertNotEqual(entities?.first!.previousID, "")
        
        CoreDataManager.sharedInstance.delete(entities!.first!)
        CoreDataManager.sharedInstance.saveContext()
    }
}