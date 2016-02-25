//
//  BoardInfoDataStoreTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/09.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
import CoreData
@testable import photoboard

class BoardInfoDataStoreTestCase: XCTestCase {

    override func setUp() {
        let entityName = NSStringFromClass(BoardInfoEntity)
            .componentsSeparatedByString(".").last! as String
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let readEntities: [BoardInfoEntity]? = CoreDataManager.sharedInstance.read(fetchRequest)
        if let readEntities = readEntities {
            for entity in readEntities {
                CoreDataManager.sharedInstance.delete(entity)
            }
        }
    }
    
    func testCombination() {
        let title = "DataSourceTest"
        let dataSource = BoardInfoDataStore()
        dataSource.create { (boardInfoEntity) -> Void in
            XCTAssertNotNil(boardInfoEntity)
            XCTAssertNil(boardInfoEntity.body)
            XCTAssertNotNil(boardInfoEntity.previousID)
            XCTAssertNotEqual(boardInfoEntity.previousID,"")
            
            boardInfoEntity.title = title
            
            dataSource.load { (entities) -> Void in
                XCTAssertNotNil(entities)
                XCTAssert(entities.count > 0)
                XCTAssertEqual(entities.first!.title, title)
                XCTAssertNotNil(entities.first!.previousID)
                XCTAssertNotEqual(entities.first!.previousID,"")
                
                dataSource.delete(entities.first!.id, completion: { () -> Void in
                    dataSource.load { (entities) -> Void in
                        XCTAssertEqual(entities.count, 0)
                    }
                })
            }
        }
    }
}
