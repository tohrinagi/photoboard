//
//  HomeViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2015/12/31.
//  Copyright © 2016 tohrinagi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomePresenterEventHandler {
    var presenter = PresenterContainer.sharedInstance.homePresenter

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.eventHandler = self
        presenter.loadBoards()
    }

    // HomePresenterEventHandler 
    func OnLoadedBoards(){
        
    }
}

