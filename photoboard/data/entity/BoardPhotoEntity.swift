//
//  BoardPhoto.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/31.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

/// ボードの写真情報
class BoardPhotoEntity : NSManagedObject {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var row: NSNumber?
    @NSManaged var section: NSNumber?
    @NSManaged var boardbody: NSManagedObject?
}