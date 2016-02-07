//
//  BoardBodyEntity.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/01.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

/// ボードの写真など、本体情報
class BoardBodyEntity: NSManagedObject {
    
    @NSManaged var id: NSNumber?
    @NSManaged var boardPhotos: NSSet?
// Insert code here to add functionality to your managed object subclass

}
