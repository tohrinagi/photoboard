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

    init( photoPath : String ) {
        self.photoPath = photoPath
        super.init()
    }
    
    func createImage() -> UIImage? {
        return UIImage(named: photoPath)
    }
    
    func rotate() {
    }
}