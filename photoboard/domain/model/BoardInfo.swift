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
    private(set) var title: String?
    private(set) var updatedAt: NSDate
    private(set) var createdAt: NSDate
    var row: Int
    var headerPath: String?
    var id: String
    
    init( id: String, title: String?, headerPath: String?,
          row: Int, createdAt: NSDate, updatedAt: NSDate) {
        self.id = id
        self.title = title
        self.headerPath = headerPath
        self.row = row
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        super.init()
    }
    
    func updated( date: NSDate ) {
        updatedAt = date
    }
    
    func renameTitle( title: String ) {
        self.title = title
    }

    func updatedString() -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateStyle = .LongStyle
        return formatter.stringFromDate(updatedAt)
    }
}
