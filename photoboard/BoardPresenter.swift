//
//  BoardPresenter.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

protocol BoardPresenterEventHandler: class {
}


class BoardPresenter {
    weak var eventHandler: BoardPresenterEventHandler?
    
}