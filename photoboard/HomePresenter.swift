//
//  HomePresenter.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

protocol HomePresenterEventHandler: class {
    func OnLoadedBoards() -> Void
}


class HomePresenter {
    weak var eventHandler: HomePresenterEventHandler?
    
    /**
     ボード情報を読み込む
     */
    func loadBoards(){
        //todo
        eventHandler?.OnLoadedBoards()
    }
}