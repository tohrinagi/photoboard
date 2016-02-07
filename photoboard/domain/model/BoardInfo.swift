//
//  BoardInfo.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/31.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボードの付加情報
class BoardInfo : NSObject {
    private(set) var title : String
    private(set) var updatedAt : NSDate
    private(set) var createdAt : NSDate
    private(set) var headerPhoto : Int = 0//TODO
    
    override init() {
        self.title = ""
        self.updatedAt = NSDate()
        self.createdAt = NSDate()
        super.init()
    }
    
    init( title : String, createdAt : NSDate, updatedAt : NSDate) {
        self.title = title
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        super.init()
    }
    
    func updated() {
        updatedAt = NSDate()
    }
    
    func renameTitle( title : String ) {
        self.title = title
    }
}
