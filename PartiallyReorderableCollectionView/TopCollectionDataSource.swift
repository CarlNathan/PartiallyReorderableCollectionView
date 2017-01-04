//
//  BottomCollectionDataSource.swift
//  PartiallyReorderableCollectionView
//
//  Created by Carl Udren on 1/3/17.
//  Copyright © 2017 Carl Udren. All rights reserved.
//

import Foundation
import UIKit

class TopCollectionDataSource: NSObject {
    
    var delegate: TopDataSourceDelegate?
    var dataItems = [UIColor.blue, UIColor.green, UIColor.red, UIColor.cyan, UIColor.brown]
    
    func numberOfItems() -> Int {
        return dataItems.count
    }
    
    func add(_ items: [UIColor]) {
        for item in items {
            dataItems.insert(item, at: 0)
        }
    }
    
    func removeItemAt(_ indexPath: IndexPath) {
        dataItems.remove(at: indexPath.row)
    }
    
}


extension TopCollectionDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = dataItems[indexPath.row]
        
        return cell
    }
}

extension TopCollectionDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //change data
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let d = delegate {
            d.topCollectionDidSelectItemAt(indexPath)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let d = delegate {
            d.topScrollViewDidScroll(scrollView)
        }
    }
    
}

extension TopCollectionDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3 - 1, height: collectionView.bounds.width / 3 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
