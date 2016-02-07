//
//  BoardInfoEntity+CoreDataProperties.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/07.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BoardInfoEntity {

    @NSManaged var createdAt: NSDate?
    @NSManaged var row: NSNumber?
    @NSManaged var title: String?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var body: BoardBodyEntity?

}
