//
//  BoardInfo.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/31.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボードの付加情報
class BoardInfo: NSObject {
    private(set) var title: String
    private(set) var updatedAt: NSDate
    private(set) var createdAt: NSDate
    private(set) var row: Int
    var id: String
    
    init( id: String, title: String, row: Int, createdAt: NSDate, updatedAt: NSDate) {
        self.id = id
        self.title = title
        self.row = row
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        super.init()
    }
    
    func updated() {
        updatedAt = NSDate()
    }
    
    func renameTitle( title: String ) {
        self.title = title
    }
}
