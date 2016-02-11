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
    let boardInfoEntity : BoardInfoEntity = CoreDataManager.sharedInstance.create()
    
    override func setUp() {
        boardInfoEntity.title = "BoardInfoMapperTest"
        boardInfoEntity.row = 1
        boardInfoEntity.updatedAt = NSDate()
        boardInfoEntity.createdAt = NSDate()
        //CoreDataManager.sharedInstance.update()
        //boardInfoEntity.updatePrevioudId()
    }
    
    func testToModel() {
        let model = mapper.ToModel(boardInfoEntity)
        XCTAssertNotNil(model)
        XCTAssertEqual(boardInfoEntity.title,model.title)
        XCTAssertEqual(boardInfoEntity.updatedAt, model.updatedAt)
        XCTAssertEqual(boardInfoEntity.createdAt, model.createdAt)
        XCTAssertEqual(boardInfoEntity.row, model.row)
        XCTAssertEqual(boardInfoEntity.id, model.id)
    }
    
    func testToListModel() {
        let entities = [boardInfoEntity]
        let listModel = mapper.ToListModel(entities)
        XCTAssertNotNil(listModel)
        XCTAssertNotNil(listModel.items.first)
        if let model = listModel.items.first {
            XCTAssertEqual(boardInfoEntity.title,model.title)
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
        model.updated()
        //TODO
        mapper.ToEntity(boardInfoEntity, info: model)
        
        XCTAssertEqual(boardInfoEntity.title,model.title)
        XCTAssertEqual(boardInfoEntity.updatedAt, model.updatedAt)
        XCTAssertEqual(boardInfoEntity.createdAt, model.createdAt)
        XCTAssertEqual(boardInfoEntity.row, model.row)
        XCTAssertEqual(boardInfoEntity.id, model.id)
    }
}
