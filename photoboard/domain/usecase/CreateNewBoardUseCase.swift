//
//  CreateNewBoardUseCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/11.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// 新規ボードを作成するユースケース
class CreateNewBoardUseCase : UseCase {
    
    private let boardInfoRepository : BoardInfoRepository = RepositoryContainer.sharedInstance.boardInfoRepository
    private(set) var boardInfo : BoardInfo?
    
    func main() {
        boardInfoRepository.createNewBoard { (boardInfo) -> Void in
            self.boardInfo = boardInfo
        }
    }
}