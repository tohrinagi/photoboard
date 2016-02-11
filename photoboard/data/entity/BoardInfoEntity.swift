//
//  BoardInfoEntity.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/07.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData


class BoardInfoEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    /// 以前のID Save後IDが変わるため変更前を保存している
    private(set) var previousID : String?
    
    /// ID
    var id : String {
        get {
            return objectID.URIRepresentation().absoluteString
        }
    }
    
    /**
     Insert時の処理
     */
    override func awakeFromInsert() {
        previousID = id
    }
    
    /**
     Fetch時の処理
     */
    override func awakeFromFetch() {
        previousID = id
    }
    
    /**
     IDの更新処理
     */
    func updatePrevioudId() {
        previousID = id
    }
    
}