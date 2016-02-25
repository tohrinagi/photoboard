//
//  PresenterContainer.swift
//  photoboard
//
//  Created by tohrinagi on 2016/01/02.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

/// Presenterを格納しておくクラス
class PresenterContainer {
    class var sharedInstance: PresenterContainer {
        struct Static {
            static let instance: PresenterContainer = PresenterContainer()
        }
        return Static.instance
    }
    private(set) var homePresenter = HomePresenter()
    private(set) var boardPresenter = BoardPresenter()
}
