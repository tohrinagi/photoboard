//
//  BoardBodyDataRepositoryTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/23.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
import CoreData
@testable import photoboard

class BoardBodyDataRepositoryTestCase: XCTestCase {

    override func setUp() {
        DataStoreUtil().deleteAllEntities()
    }

    func testCombination() {
        let infoStore = BoardInfoDataStore()
        let bodyStore = BoardBodyDataStore()
        let photoStore = BoardPhotoDataStore()
        let infoRepository = BoardInfoDataRepository(infoStore: infoStore)
        let bodyRepository = BoardBodyDataRepository(
            infoStore: infoStore, bodyStore: bodyStore, photoStore: photoStore)
        
        infoRepository.create { (info) -> Void in
                XCTAssertNotNil(info)
            bodyRepository.create(info, completion: { (body) -> Void in
                XCTAssertNotNil(body)
                XCTAssertEqual(info.id, body.info.id)
                
                bodyRepository.createPhoto(body, completion: { (photo) -> Void in
                    XCTAssertNotNil(photo)
                    XCTAssertEqual(body.photos.count, 1)
                    XCTAssertEqual(body.photos.first!, photo)
                    
                    bodyRepository.update(body, completion: { () -> Void in
                        infoRepository.read({ (infoList) -> Void in
                            XCTAssertEqual(infoList.count, 1)
                            bodyRepository.read(infoList.first!, completion: { (body) -> Void in
                                XCTAssertEqual(body.photos.count, 1)
                            })
                        })
                    })
                })
            })
        }
    }
    
    func testIdUpdate() {
        let infoStore = BoardInfoDataStore()
        let bodyStore = BoardBodyDataStore()
        let photoStore = BoardPhotoDataStore()
        let infoRepository = BoardInfoDataRepository(infoStore: infoStore)
        let bodyRepository = BoardBodyDataRepository(
            infoStore: infoStore, bodyStore: bodyStore, photoStore: photoStore)
        
        
        infoRepository.create { (info) -> Void in
            bodyRepository.create(info, completion: { (body) -> Void in
                bodyRepository.createPhoto(body, completion: { (photo) -> Void in
                    
                    bodyRepository.update(body, completion: { () -> Void in
                        bodyRepository.read(info, completion: { (body2) -> Void in
                            XCTAssertEqual(body.id, body2.id)
                            XCTAssertEqual(photo.id, body2.photos.first!.id)
                        })
                    })
                })
            })
        }
        
    }
}
