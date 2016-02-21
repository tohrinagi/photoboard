//
//  BoadPhoto.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/31.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import UIKit

class BoardPhoto : NSObject {
    var photoPath : String
    var section : Int
    var row : Int
    var id : String

    init( id : String, photoPath : String, section : Int, row : Int ) {
        self.id = id
        self.photoPath = photoPath
        self.section = section
        self.row = row
        super.init()
    }
    
    init( id : String ) {
        self.id = id
        self.photoPath = ""
        self.section = 0
        self.row = 0
        super.init()
    }
    
    func createImage() -> UIImage? {
        return UIImage(named: photoPath)
    }
    
    var referenceURL : NSURL {
        get {
            return NSURL(string: photoPath)!
        }
    }
    
    var IndexPath : NSIndexPath {
        get {
            return NSIndexPath(forRow: row, inSection: section)
        }
    }
}