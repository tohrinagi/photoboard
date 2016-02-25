//
//  BoardInfoDataRepositoryTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/11.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
import CoreData
@testable import photoboard

class BoardInfoDataRepositoryTestCase: XCTestCase {

    override func setUp() {
        let fetchRequest = NSFetchRequest(entityName: "BoardInfoEntity")
        let readEntities: [BoardInfoEntity]? = CoreDataManager.sharedInstance.read(fetchRequest)
        if let readEntities = readEntities {
            for entity in readEntities {
                CoreDataManager.sharedInstance.delete(entity)
            }
        }
    }
    func testCombination() {
        let infoStore = BoardInfoDataStore()
        let repository = BoardInfoDataRepository(infoStore: infoStore)
        let title = "InfoDataReso"
        
        repository.read { (infoList1) -> Void in
            XCTAssertEqual(infoList1.count, 0)
         
            repository.create({ (info) -> Void in
                XCTAssertNotNil(info)
                info.renameTitle(title)
                
                repository.read({ (infoList2) -> Void in
                    XCTAssertEqual(infoList2.count, 1)
                 
                    repository.delete(info, completion: { () -> Void in
                    repository.read({ (infoList3) -> Void in
                        XCTAssertEqual(infoList3.count, 0)
                        })
                    })
                })
            })
        }
    }
    
    func testIdUpdate() {
        let infoStore = BoardInfoDataStore()
        let repository = BoardInfoDataRepository(infoStore: infoStore)
        
        repository.create { (info1) -> Void in
            XCTAssertNotNil(info1)
            info1.renameTitle("info1")
            repository.create { (info2) -> Void in
                XCTAssertNotNil(info2)
                info2.renameTitle("info2")
                repository.read({ (infoList) -> Void in
                    XCTAssertEqual(infoList.filter {$0.id == info1.id}.count, 1)
                    XCTAssertEqual(infoList.filter {$0.id == info2.id}.count, 1)
                })
            }
        }
    }
}
