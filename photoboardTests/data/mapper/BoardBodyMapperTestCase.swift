//
//  BoardBodyMapperTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/23.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
@testable import photoboard

class BoardBodyMapperTestCase: XCTestCase {
    
    let mapper = BoardBodyMapper()
    let boardInfoEntity = CoreDataManager.sharedInstance.create() as BoardInfoEntity
    let boardBodyEntity = CoreDataManager.sharedInstance.create() as BoardBodyEntity
    let boardPhotoEntity = CoreDataManager.sharedInstance.create() as BoardPhotoEntity
    
    override func setUp() {
        boardInfoEntity.title = "BoardBodyMapperTestInfo"
        boardInfoEntity.row = 1
        boardInfoEntity.updatedAt = NSDate()
        boardInfoEntity.createdAt = NSDate()
        
        boardPhotoEntity.name = "BoardBodyMapperTestPhoto"
        boardPhotoEntity.section = 1
        boardPhotoEntity.row = 2
    }
    
    func testToModel() {
        let model = mapper.ToModel(boardInfoEntity, bodyEntity: boardBodyEntity, photoEntities: [boardPhotoEntity])
        XCTAssertNotNil(model)
        XCTAssertEqual(boardInfoEntity.title, model.info.title)
        XCTAssertEqual(boardInfoEntity.updatedAt, model.info.updatedAt)
        XCTAssertEqual(boardInfoEntity.createdAt, model.info.createdAt)
        XCTAssertEqual(boardInfoEntity.row, model.info.row)
        XCTAssertEqual(boardInfoEntity.id, model.info.id)
        XCTAssertEqual(boardBodyEntity.id, model.id)
        XCTAssertEqual(boardPhotoEntity.id, model.photos.first!.id)
        XCTAssertEqual(boardPhotoEntity.name, model.photos.first!.photoPath)
        XCTAssertEqual(boardPhotoEntity.section, model.photos.first!.section)
        XCTAssertEqual(boardPhotoEntity.row, model.photos.first!.row)
    }
}
