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
    
    func numberOfItems() -> Int {
        return 4
    }
    
}


extension TopCollectionDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        switch indexPath.item {
        case 0:
            cell.backgroundColor = UIColor.red
            break
        case 1:
            cell.backgroundColor = UIColor.green
            break
        case 2:
            cell.backgroundColor = UIColor.purple
            break
        default:
            cell.backgroundColor = UIColor.orange
        }
        
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
        //
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
