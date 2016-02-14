//
//  BoardPresenter.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

protocol BoardPresenterEventHandler: class {
    func OnLoadedBoard( board : BoardBody ) -> Void
    func OnAddedPhoto( photo : BoardPhoto ) -> Void
}

/// Board画面用プレゼンター
class BoardPresenter {
    weak var eventHandler: BoardPresenterEventHandler?
    
    func loadBoardBody( boardInfo : BoardInfo ) {
        let task = GetBoardBodyUseCase(boardInfo: boardInfo)
        TaskManager.startBackground(task) {
            (task) -> Void in
            //TODO エラーの場合!だとまずい
            self.eventHandler?.OnLoadedBoard(task.boardBody!)
        }
    }

    func addPhoto( boardBody : BoardBody, referenceUrl : String, section : Int, row : Int ) {
        let task = AddBoardPhotoUseCase(boardBody: boardBody, url: referenceUrl, section: section, row: row)
        TaskManager.startBackground(task) { (task) -> Void in
            self.eventHandler?.OnAddedPhoto(task.boardPhoto!)
        }
    }
}