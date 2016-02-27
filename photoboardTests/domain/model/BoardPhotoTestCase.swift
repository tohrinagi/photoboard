//
//  BoardPhotoTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/27.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
@testable import photoboard

class BoardPhotoTestCase: XCTestCase {

    let photo = BoardPhoto(id: "testPhoto", photoPath: "Path", section: 1, row: 1)
    
    func testParams() {
        XCTAssertEqual(photo.referenceURL, NSURL(string: "Path"))
        XCTAssertEqual(photo.indexPath, NSIndexPath(forRow: 1, inSection: 1))
    }

}
