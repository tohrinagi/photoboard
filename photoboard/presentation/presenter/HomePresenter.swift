//
//  HomePresenter.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

protocol HomePresenterEventHandler: class {
    func OnLoadedBoards(boards : BoardInfoList) -> Void
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
            self.eventHandler?.OnLoadedBoards(task.boardInfoList!)
        }
    }
}
