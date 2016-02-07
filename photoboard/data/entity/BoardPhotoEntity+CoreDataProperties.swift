//
//  BoardPhotoEntity+CoreDataProperties.swift
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

extension BoardPhotoEntity {

    @NSManaged var name: String?
    @NSManaged var row: NSNumber?
    @NSManaged var section: NSNumber?
    @NSManaged var body: BoardBodyEntity?

}
