//
//  CreateNewBoardUseCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/11.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// 新規ボードを作成するユースケース
class CreateNewBoardUseCase: UseCase {
    
    private let boardInfoRepository = RepositoryContainer.sharedInstance.boardInfoRepository
    private let boardBodyRepository = RepositoryContainer.sharedInstance.boardBodyRepository
    private(set) var boardBody: BoardBody?
    
    func main() {
        boardInfoRepository.create { (info) -> Void in
            self.boardBodyRepository.create(info, completion: { (body) -> Void in
                self.boardBody = body
            })
        }
    }
}
