//
//  BoardInfoRepository.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/05.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

protocol BoardInfoRepository {
    func getBoardInfoList( completion : (BoardInfoList)->Void )
    func updateBoardInfoList( boardInfoList : BoardInfoList, completion : (Bool)->Void )
    func createNewBoard( completion : (BoardInfo)->Void )
}