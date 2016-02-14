//
//  AddBoardPhotoUseCase.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/14.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/// ボードに写真を追加するユースケース
class AddBoardPhotoUseCase : UseCase {
    
    private let boardInfoRepository : BoardInfoRepository = RepositoryContainer.sharedInstance.boardInfoRepository
    private let boardBody : BoardBody
    private let url : String
    private let section : Int
    private let row : Int
    private(set) var boardPhoto : BoardPhoto?
    
    init( boardBody : BoardBody, url : String, section : Int, row : Int ){
        self.boardBody = boardBody
        self.url = url
        self.section = section
        self.row = row
    }
    
    func main() {
        boardInfoRepository.addBoardPhoto(boardBody, referenceUrl: url, section: section, row: row) { (boardPhoto) -> Void in
            self.boardPhoto = boardPhoto
        }
    }
}