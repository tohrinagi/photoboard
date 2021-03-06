//
//  BoardInfoMapperTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/11.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
@testable import photoboard

class BoardInfoMapperTestCase: XCTestCase {
    
    let mapper = BoardInfoMapper()
    var boardInfoEntity: BoardInfoEntity = DataStoreUtil().createBoardInfoEntity()
    
    override func setUp() {
        boardInfoEntity.title = "BoardInfoMapperTest"
        boardInfoEntity.row = 1
        boardInfoEntity.updatedAt = NSDate()
        boardInfoEntity.createdAt = NSDate()
    }
    
    func testToModel() {
        let model = mapper.ToModel(boardInfoEntity)
        XCTAssertNotNil(model)
        XCTAssertEqual(boardInfoEntity.title, model.title)
        XCTAssertEqual(boardInfoEntity.updatedAt, model.updatedAt)
        XCTAssertEqual(boardInfoEntity.createdAt, model.createdAt)
        XCTAssertEqual(boardInfoEntity.row, model.row)
        XCTAssertEqual(boardInfoEntity.id, model.id)
    }
    
    func testToListModel() {
        let entities = [boardInfoEntity]
        let listModel = mapper.ToListModel(entities)
        XCTAssertNotNil(listModel)
        XCTAssertEqual(listModel.count, 1)
        if let model = listModel.first {
            XCTAssertEqual(boardInfoEntity.title, model.title)
            XCTAssertEqual(boardInfoEntity.updatedAt, model.updatedAt)
            XCTAssertEqual(boardInfoEntity.createdAt, model.createdAt)
            XCTAssertEqual(boardInfoEntity.row, model.row)
            XCTAssertEqual(boardInfoEntity.id, model.id)
        }
    }
    
    func testToEntity() {
        NSLog(boardInfoEntity.id)
        NSLog("\(boardInfoEntity.title)")
        NSLog("\(boardInfoEntity.row)")
        NSLog("\(boardInfoEntity.updatedAt)")
        NSLog("\(boardInfoEntity.createdAt)")
        let model = mapper.ToModel(boardInfoEntity)
        
        model.renameTitle("BoardInfoMapperTestToEntity")
        model.updated(NSDate())
        mapper.ToEntity(boardInfoEntity, model: model)
        
        XCTAssertEqual(boardInfoEntity.title, model.title)
        XCTAssertEqual(boardInfoEntity.updatedAt, model.updatedAt)
        XCTAssertEqual(boardInfoEntity.createdAt, model.createdAt)
        XCTAssertEqual(boardInfoEntity.row, model.row)
        XCTAssertEqual(boardInfoEntity.id, model.id)
    }
}
