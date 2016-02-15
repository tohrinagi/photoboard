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
    
    private let boardInfoRepository : BoardInfoRepository = RepositoryContainer.sharedInstance.boardInfoRepository
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
        boardInfoRepository.moveBoardPhoto(boardBody, from: from, to: to) { (from, to) -> Void in
            self.fromPhoto = from
            self.toPhoto = to
        }
    }
}