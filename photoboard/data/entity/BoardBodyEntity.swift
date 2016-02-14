//
//  BoardBodyEntity.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/07.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData


class BoardBodyEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func addPhoto( photo : BoardPhotoEntity ) {
        let items = self.mutableSetValueForKey("photos")
        items.addObject(photo)
    }
}
