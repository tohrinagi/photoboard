//
//  BoardCollectionViewCell.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/03.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
