//
//  BoardPhotoMapperTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/24.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
@testable import photoboard

class BoardPhotoMapperTestCase: XCTestCase {
    
    let mapper = BoardPhotoMapper()
    let boardPhotoEntity = CoreDataManager.sharedInstance.create() as BoardPhotoEntity
    
    override func setUp() {
        boardPhotoEntity.name = "BoardBodyMapperTestPhoto"
        boardPhotoEntity.section = 1
        boardPhotoEntity.row = 2
    }
    
    func testToModel() {
        let model = mapper.ToModel(boardPhotoEntity)
        XCTAssertNotNil(model)
        XCTAssertEqual(boardPhotoEntity.id, model.id)
        XCTAssertEqual(boardPhotoEntity.name, model.photoPath)
        XCTAssertEqual(boardPhotoEntity.section, model.section)
        XCTAssertEqual(boardPhotoEntity.row, model.row)
 
        model.photoPath = "BoardBodyMapperTestPhoto2"
        model.section = 2
        model.row = 3
        mapper.ToEntity(boardPhotoEntity, model: model)
        XCTAssertEqual(boardPhotoEntity.id, model.id)
        XCTAssertEqual(boardPhotoEntity.name, model.photoPath)
        XCTAssertEqual(boardPhotoEntity.section, model.section)
        XCTAssertEqual(boardPhotoEntity.row, model.row)
    }
    
    func testToListModel() {
        let model = mapper.ToListModel([boardPhotoEntity])
        XCTAssertNotNil(model)
        XCTAssertEqual(model.count, 1)
        XCTAssertEqual(boardPhotoEntity.id, model.first!.id)
        XCTAssertEqual(boardPhotoEntity.name, model.first!.photoPath)
        XCTAssertEqual(boardPhotoEntity.section, model.first!.section)
        XCTAssertEqual(boardPhotoEntity.row, model.first!.row)
        
        model.first!.photoPath = "BoardBodyMapperTestPhoto3"
        model.first!.section = 3
        model.first!.row = 4
        mapper.ToListEntity([boardPhotoEntity], models: model)
        XCTAssertEqual(boardPhotoEntity.id, model.first!.id)
        XCTAssertEqual(boardPhotoEntity.name, model.first!.photoPath)
        XCTAssertEqual(boardPhotoEntity.section, model.first!.section)
        XCTAssertEqual(boardPhotoEntity.row, model.first!.row)
    }
}
