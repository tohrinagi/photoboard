//
//  BoardPhotoDataStoreTestCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/23.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import XCTest
import CoreData
@testable import photoboard

class BoardPhotoDataStoreTestCase: XCTestCase {

    override func setUp() {
        DataStoreUtil().deleteAllEntities()
    }
    
    func testCombination() {
        let infoDataStore = BoardInfoDataStore()
        let bodyDataStore = BoardBodyDataStore()
        let photoDataStore = BoardPhotoDataStore()
        infoDataStore.create { (info) -> Void in
            XCTAssertNotNil(info)
            bodyDataStore.create(info, completion: { (body) -> Void in
                XCTAssertNotNil(body)
            
                photoDataStore.create(body, completion: { (photo) -> Void in
                    XCTAssertNotNil(photo)
                    XCTAssertNotNil(body.photos)
                    XCTAssertEqual(body.photos?.count, 1)
                    XCTAssertNotNil(photo.previousID)
                    XCTAssertNotEqual(photo.previousID,"")
                    
                    photoDataStore.load(body, completion: { (photos) -> Void in
                        XCTAssertEqual(photos.count, 1)
                        XCTAssertNotNil(photos.first!.previousID)
                        XCTAssertNotEqual(photos.first!.previousID,"")
                        
                        photoDataStore.search(photo.id, completion: { (photo1) -> Void in
                            XCTAssertNotNil(photo1)
                            XCTAssertNotNil(photo1.previousID)
                            XCTAssertNotEqual(photo1.previousID,"")
                         
                            photoDataStore.delete(photo.id, completion: { () -> Void in
                                do {
                                    try CoreDataManager.sharedInstance.saveContext()
                                    photoDataStore.load(body, completion: { (photos2) -> Void in
                                        XCTAssertEqual(photos2.count, 0)
                                    })
                                } catch {
                                    
                                }
                            })
                        })
                    })
                })
            })
        }
    }
}
