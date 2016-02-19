//
//  BoardInfoRepository.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/05.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

protocol BoardInfoRepository {
    func create( completion : (BoardInfo)->Void )
    func read( completion : ([BoardInfo])->Void )
    func update( boardInfoList : [BoardInfo], completion : ()->Void )
}