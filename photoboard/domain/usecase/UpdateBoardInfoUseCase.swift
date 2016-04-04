//
//  UpdateBoardInfoUseCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/04/03.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

class UpdateBoardInfoUseCase: UseCase {
    
    private let boardInfoRepository = RepositoryContainer.sharedInstance.boardInfoRepository
    private let boards: [BoardInfo]
    
    init( boards: [BoardInfo] ) {
        self.boards = boards
    }
    
    func main() {
        //モデルの書き込みをリポジトリに指示する
        boardInfoRepository.update(boards) { () -> Void in
        }
        
    }
}
