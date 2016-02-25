//
//  HomeCollectionViewCell.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/30.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//
import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
