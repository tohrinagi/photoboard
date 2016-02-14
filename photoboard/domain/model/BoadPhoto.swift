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
    let photoPath : String
    let section : Int
    let row : Int

    init( photoPath : String, section : Int, row : Int ) {
        self.photoPath = photoPath
        self.section = section
        self.row = row
        super.init()
    }
    
    func createImage() -> UIImage? {
        return UIImage(named: photoPath)
    }
    
    var IndexPath : NSIndexPath {
        get {
            return NSIndexPath(forRow: row, inSection: section)
        }
    }
}