//
//  GetBoardInfoListUseCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/31.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボードセットを取得するビジネスロジック
class GetBoardInfoListUseCase: UseCase {
    private let boardInfoRepository = RepositoryContainer.sharedInstance.boardInfoRepository
    private(set) var boardInfoList = [BoardInfo]()
    
    func main() {
        boardInfoRepository.read {
            (boardInfoList) -> Void in
            self.boardInfoList = boardInfoList
        }
    }
    
    //TODO task でバッググラウンド開始で、（）->Void の待つ処理は…？？？
}
