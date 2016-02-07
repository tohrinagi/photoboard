//
//  BoardinfoList.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/31.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

class BoardInfoList: NSObject {
    private(set) var items : [BoardInfo]
    
    init( boardInfos : [BoardInfo]){
        self.items = boardInfos
        super.init()
    }

    /*
    func createNewBoard() -> BoardInfo {
        let new = BoardInfo()
        items.append(new)
        return new
    }
    
    func deleteBoard( id : Int ) {
    }
    
    func moveBoard( movedId : Int, insertAt : Int ) {
    }*/
}