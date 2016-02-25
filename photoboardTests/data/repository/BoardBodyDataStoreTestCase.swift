//
//  BoardBodyDataStoreTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/23.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
import CoreData
@testable import photoboard

class BoardBodyDataStoreTestCase: XCTestCase {

    override func setUp() {
        let fetchRequest = NSFetchRequest(entityName: "BoardBodyEntity")
        let readEntities: [BoardBodyEntity]? = CoreDataManager.sharedInstance.read(fetchRequest)
        if let readEntities = readEntities {
            for entity in readEntities {
                CoreDataManager.sharedInstance.delete(entity)
            }
        }
    }
    
    func testCombination() {
        let infoDataStore = BoardInfoDataStore()
        let bodyDataStore = BoardBodyDataStore()
        infoDataStore.create { (info) -> Void in
            XCTAssertNotNil(info)
            bodyDataStore.create(info, completion: { (body1) -> Void in
                XCTAssertNotNil(body1)
                XCTAssertNotNil(info.body)
                XCTAssertNotNil(body1.previousID)
                XCTAssertNotEqual(body1.previousID,"")
            
                bodyDataStore.load(info, completion: { (body2) -> Void in
                    XCTAssertNotNil(body2)
                    XCTAssertNotNil(info.body)
                    XCTAssertNotNil(body2!.previousID)
                    XCTAssertNotEqual(body2!.previousID,"")
                 
                    bodyDataStore.search(body2!.id, completion: { (body3) -> Void in
                        XCTAssertNotNil(body3)
                        XCTAssertNotNil(body3!.previousID)
                        XCTAssertNotEqual(body3!.previousID,"")
                        bodyDataStore.delete(body3!.id, completion: { () -> Void in
                            CoreDataManager.sharedInstance.saveContext()
                            bodyDataStore.load(info, completion: { (body4) -> Void in
                                XCTAssertNil(body4)
                            })
                        })
                    })
                })
            })
        }
    }
}
