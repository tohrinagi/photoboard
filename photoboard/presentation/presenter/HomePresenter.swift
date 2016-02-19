//
//  HomePresenter.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

protocol HomePresenterEventHandler: class {
    func OnLoadedBoards(boards : [BoardInfo]) -> Void
    func OnCreatedNewBoard( board : BoardInfo ) -> Void
}

class HomePresenter {
    weak var eventHandler: HomePresenterEventHandler?
    
    init(){
    }
    
    /**
     ボード情報を読み込む
     */
    func loadBoardInfoList(){
        let task = GetBoardInfoListUseCase()
        TaskManager.startBackground(task) {
            (task) -> Void in
            self.eventHandler?.OnLoadedBoards(task.boardInfoList)
        }
    }
    
    /**
     新しいボードを作成する
     */
    func createNewBoard() {
        let task = CreateNewBoardUseCase()
        TaskManager.startBackground(task) { (task) -> Void in
            self.eventHandler?.OnCreatedNewBoard(task.boardBody!.info)
        }
    }
}
