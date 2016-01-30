//
//  HomeViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2015/12/31.
//  Copyright © 2016 tohrinagi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var presenter = PresenterContainer.sharedInstance.homePresenter
    var images : [UIImage] = []
    
    @IBOutlet weak var homeCollectionView: HomeCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.eventHandler = self
        presenter.loadBoards()
        
        //TODO
        if let image = UIImage(named: "cat.jpg") {
            images.append(image)
        }
    }

}

extension HomeViewController : DraggableCollectionDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCollectionViewCell
        
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    
        //TODO モデルに入れ替え通知
        let sourceImage = images.removeAtIndex(sourceIndexPath.row)
        images.insert(sourceImage, atIndex: destinationIndexPath.row)
        print("srcSec:\(sourceIndexPath.section) srcRow:\(sourceIndexPath.row) -> dstSec:\(destinationIndexPath.section) dstRow:\(destinationIndexPath.row)")
    }
    
    func finishedMove(collectionView: UICollectionView ) {
        print("finishedMove")
    }
}

extension HomeViewController : HomePresenterEventHandler {
    
    func OnLoadedBoards(){
    }
}