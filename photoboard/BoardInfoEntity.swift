//
//  BoardInfoEntity.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/01.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

/// ボードの詳細情報
class BoardInfoEntity: NSManagedObject {

    @NSManaged var createdAt: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var row: NSNumber?
    @NSManaged var title: String?
    @NSManaged var updatedAt: NSDate?
// Insert code here to add functionality to your managed object subclass

}
