//
//  MoveBoardPhotoUseCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/15.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボードの写真を移動するユースケース
class MoveBoardPhotoUseCase : UseCase {
    
    private let boardBodyRepository = RepositoryContainer.sharedInstance.boardBodyRepository
    private let boardBody : BoardBody
    private let from : NSIndexPath
    private let to : NSIndexPath
    private(set) var fromPhoto : BoardPhoto?
    private(set) var toPhoto : BoardPhoto?
    
    init( boardBody : BoardBody, from : NSIndexPath, to : NSIndexPath ){
        self.boardBody = boardBody
        self.from = from
        self.to = to
    }
    
    func main() {
        //入れ替え処理を行う
        
        
        //モデルの書き込みをリポジトリに指示する
        boardBodyRepository.update(boardBody) { () -> Void in
            //noting
        }
        
    }
}