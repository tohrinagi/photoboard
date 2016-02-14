//
//  BoardBodyDataSorce.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/14.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

class BoardBodyDataSource {
    
    func createEntity( boardBody : BoardBodyEntity, completion : (BoardPhotoEntity)->Void ) {
        let photo : BoardPhotoEntity = CoreDataManager.sharedInstance.create()
        boardBody.addPhoto( photo )
        completion( photo )
    }
}