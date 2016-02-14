//
//  BoardInfoRepository.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/05.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

protocol BoardInfoRepository {
    func readBoardInfoList( completion : (BoardInfoList)->Void )
    func updateBoardInfoList( boardInfoList : BoardInfoList, completion : (Bool)->Void )
    func createNewBoard( completion : (BoardInfo)->Void )
    func readBoardBody( boardInfo : BoardInfo, completion : (Bool,BoardBody?)->Void )
    func addBoardPhoto( boardBody : BoardBody, referenceUrl : String, section : Int, row : Int, completion : (BoardPhoto)->Void )
}