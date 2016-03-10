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
    private let title: String
    private let date: NSDate
    
    init( title: String, date: NSDate ) {
        self.title = title
        self.date = date
    }
    
    func main() {
        boardInfoRepository.create { (info) -> Void in
            info.renameTitle(self.title)
            info.updated(self.date)
            self.boardBodyRepository.create(info, completion: { (body) -> Void in
                self.boardBodyRepository.update(body, completion: { () -> Void in
                    self.boardBody = body
                })
            })
        }
    }
}
