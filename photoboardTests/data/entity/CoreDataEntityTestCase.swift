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
        DataStoreUtil().deleteAllEntities()
    }
    
    func testCreate() {
        let entity = DataStoreUtil().createBoardInfoEntity()
        XCTAssertNotNil(entity)
        XCTAssertNotNil(entity.previousID)
        XCTAssertNotEqual(entity.previousID, "")
    }
    
    func testFetch() {
        DataStoreUtil().createBoardInfoEntity()
        DataStoreUtil().save()
        
        let fetchRequest = NSFetchRequest(entityName: "BoardInfoEntity")
        do {
            let entities = try CoreDataManager
                .sharedInstance.read(fetchRequest) as [BoardInfoEntity]?
            XCTAssertNotNil(entities)
            XCTAssertEqual(entities?.count, 1)
            XCTAssertNotNil(entities?.first!.previousID)
            XCTAssertNotEqual(entities?.first!.previousID, "")
            CoreDataManager.sharedInstance.delete(entities!.first!)
        } catch {
            XCTAssert(false)
        }
        
        DataStoreUtil().save()
    }
}
