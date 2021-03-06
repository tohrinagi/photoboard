//
//  GetBoardBodyUseCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/01.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation


/// ボードの本体情報を取得するビジネスロジック
class GetBoardBodyUseCase: UseCase {
    private let boardBodyRepository = RepositoryContainer.sharedInstance.boardBodyRepository
    private let boardInfo: BoardInfo
    private(set) var boardBody: BoardBody? = nil
    
    init( boardInfo: BoardInfo ) {
        self.boardInfo = boardInfo
    }
    
    func main() {
        boardBodyRepository.read(boardInfo) { (boardBody) -> Void in
            self.boardBody = boardBody
        }
    }
}
