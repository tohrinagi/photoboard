//
//  photoboardUITests.swift
//  photoboardUITests
//
//  Created by tohrinagi on 2015/12/31.
//  Copyright © 2015年 tohrinagi. All rights reserved.
//

import XCTest

class PhotoboardUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
    }
    
}
