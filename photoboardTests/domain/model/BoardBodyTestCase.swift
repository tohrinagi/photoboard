//
//  BoardBodyTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/27.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
@testable import photoboard

class BoardBodyTestCase: XCTestCase {
    
    var info: BoardInfo!
    var body: BoardBody!
    var photos = [BoardPhoto]()
    
    override func setUp() {
        info = BoardInfo(id: "testInfo", title: "Title",
            headerPath: nil,
            row: 0, createdAt: NSDate(), updatedAt: NSDate())
        body = BoardBody(id: "testBody", info: info, photos: [])
        let photo1 = BoardPhoto(id: "testPhoto1", photoPath: "Path1", section: 0, row: 0)
        photos.append(photo1)
        let photo2 = BoardPhoto(id: "testPhoto2", photoPath: "Path2", section: 0, row: 1)
        photos.append(photo2)
    }

    func testPhoto() {
        for photo in photos {
            body.addPhoto(photo)
        }
        XCTAssertEqual(body.photos.count, 2)
        
        let index0 = NSIndexPath(forRow: 0, inSection: 0)
        let photo0 = body.photo(index0)
        XCTAssertEqual(photo0.section, 0)
        XCTAssertEqual(photo0.row, 0)
        XCTAssertEqual(photo0.photoPath, "Path1")
        
        let index1 = NSIndexPath(forRow: 1, inSection: 0)
        let photo1 = body.photo(index1)
        XCTAssertEqual(photo1.section, 0)
        XCTAssertEqual(photo1.row, 1)
        XCTAssertEqual(photo1.photoPath, "Path2")
        
        body.movePhoto(index0, to: index1)
        let photo2 = body.photo(index0)
        XCTAssertEqual(photo2.section, 0)
        XCTAssertEqual(photo2.row, 0)
        XCTAssertEqual(photo2.photoPath, "Path2")
        
        let photo3 = body.photo(index1)
        XCTAssertEqual(photo3.section, 0)
        XCTAssertEqual(photo3.row, 1)
        XCTAssertEqual(photo3.photoPath, "Path1")
        
        body.deletePhoto(photo0)
        body.deletePhoto(photo1)
        XCTAssertEqual(body.photos.count, 0)
    }
}
