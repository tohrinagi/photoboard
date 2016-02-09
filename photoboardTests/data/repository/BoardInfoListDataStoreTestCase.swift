//
//  BoardInfoListDataStoreTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/09.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
@testable import photoboard

class BoardInfoListDataStoreTestCase: XCTestCase {

    func testCombination() {
        let title = "DataSourceTest"
        let dataSource = BoardInfoListDataStore()
        dataSource.createEntity { (boardInfoEntity) -> Void in
            XCTAssertNotNil(boardInfoEntity)
            
            boardInfoEntity.title = title
            
            dataSource.updateEntity(boardInfoEntity, completion: { (success) -> Void in
                XCTAssert(success)
                
                dataSource.readAllEntity{ (success, entities) -> Void in
                    XCTAssert(success)
                    XCTAssertNotNil(entities)
                    XCTAssert(entities!.count > 0)
                    XCTAssertEqual(entities!.first!.title, title)
                    
                    dataSource.deleteEntity(entities!.first!, completion: { (success) -> Void in
                        XCTAssert(success)
                        
                        dataSource.readAllEntity{ (success, entities) -> Void in
                            XCTAssert(success)
                            XCTAssertEqual(entities!.count,0)
                        }
                    })
                }
            })
        }
    }
}
