//
//  BoardInfoDataRepositoryTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/11.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
import CoreData
@testable import photoboard

class BoardInfoDataRepositoryTestCase: XCTestCase {

    override func setUp() {
        let entityName = NSStringFromClass(BoardInfoEntity).componentsSeparatedByString(".").last! as String
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let readEntities : [BoardInfoEntity]? = CoreDataManager.sharedInstance.read(fetchRequest)
        if let readEntities = readEntities {
            for entity in readEntities {
                CoreDataManager.sharedInstance.delete(entity)
            }
        }
    }
    func testCombination() {
        let repository = BoardInfoDataRepository()
        
        repository.getBoardInfoList { (boardInfoList) -> Void in
            XCTAssertEqual(boardInfoList.items.count, 0)
            
            //TODO 更新する
            repository.updateBoardInfoList(boardInfoList, completion: { (success) -> Void in
                XCTAssert(success)
                
                //TODO 削除する
                /*repository.deleteBoardInfoList(BoardInfo, completion: { (success)-> Void in
                })*/
            })
        }
    }
}
