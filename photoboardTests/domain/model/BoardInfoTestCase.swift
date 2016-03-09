//
//  BoardInfoTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/27.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
@testable import photoboard

class BoardInfoTestCase: XCTestCase {
    
    let info = BoardInfo(id: "testId",
        title: "testTitle", row: 1, createdAt: NSDate(), updatedAt: NSDate() )

    func testParams() {
        let date = info.updatedAt
        info.updated(NSDate())
        XCTAssertGreaterThan(info.updatedAt.timeIntervalSince1970, date.timeIntervalSince1970)
        
        info.renameTitle("renamedTitle")
        XCTAssertEqual(info.title, "renamedTitle")
    }

}
