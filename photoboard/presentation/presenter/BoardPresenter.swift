//
//  BoardPresenter.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

protocol BoardPresenterEventHandler: class {
    func OnLoadedBoard( board : BoardBody ) -> Void
    func OnAddedPhoto( referenceUrl : String ) -> Void
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

    func addPhoto( referenceUrl : String ) {
        
    }
}