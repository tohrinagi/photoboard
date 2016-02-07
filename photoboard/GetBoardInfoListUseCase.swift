//
//  GetBoardInfoListUseCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/31.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボードセットを取得するビジネスロジック
class GetBoardInfoListUseCase : UseCase {
    private let boardInfoRepository : BoardInfoRepository = RepositoryContainer.sharedInstance.boardInfoRepository
    private(set) var boardInfoList : BoardInfoList?
    
    func main() {
        boardInfoRepository.getBoardInfoList {
            (boardInfoList) -> Void in
            self.boardInfoList = boardInfoList
        }
    }
}