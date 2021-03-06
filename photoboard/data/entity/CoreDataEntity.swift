//
//  CoreDataEntity.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/17.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataEntity: NSManagedObject {
    
    /// 以前のID Save後IDが変わるため変更前を保存している
    private(set) var previousID: String?
    
    /// ID
    var id: String {
        get {
            return objectID.URIRepresentation().absoluteString
        }
    }
    
    override func awakeFromInsert() {
        updatePrevioudId()
    }
    
    override func awakeFromFetch() {
        updatePrevioudId()
    }
    
    /**
     IDの更新処理
     */
    func updatePrevioudId() {
        previousID = id
    }
}
