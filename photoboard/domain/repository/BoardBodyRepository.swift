//
//  BoardBodyRepository.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/19.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

protocol BoardBodyRepository {
    func create( boardInfo : BoardInfo, completion : (BoardBody)->Void )
    func read( boardInfo : BoardInfo, completion : (BoardBody)->Void )
    func update( boardBody : BoardBody, completion : ()->Void )
    
    func createPhoto( boardBody : BoardBody, completion : (BoardPhoto)->Void )
    func deletePhoto( boardPhoto : BoardPhoto, completion : ()->Void )
}