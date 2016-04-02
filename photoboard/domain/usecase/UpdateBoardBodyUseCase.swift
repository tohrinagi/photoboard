//
//  UpdateBoardBodyUseCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/04/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボードの情報を設定・更新するユースケース
class UpdateBoardBodyUseCase: UseCase {
    
    private let boardBodyRepository = RepositoryContainer.sharedInstance.boardBodyRepository
    private let boardBody: BoardBody
    
    init( boardBody: BoardBody ) {
        self.boardBody = boardBody
    }
    
    func main() {
        //モデルの書き込みをリポジトリに指示する
        boardBodyRepository.update(boardBody) { () -> Void in
        }
        
    }
}
