//
//  TopCollectionDataSource.swift
//  PartiallyReorderableCollectionView
//
//  Created by Carl Udren on 1/4/17.
//  Copyright © 2017 Carl Udren. All rights reserved.
//

import Foundation
import UIKit

class BottomCollectionDataSource: NSObject {
    //MARK: Properties
    public var delegate: BottomDataSourceDelegate?
    //FIXME: Change Data Type
    let dataItems = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
}

extension BottomCollectionDataSource: UICollectionViewDataSource {
    //MARK: Collection View Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let d = delegate {
            return dataItems.count + d.numberOfItemsInTopCollection()
        }
        return dataItems.count
    }
    //FIXME: Change Cell Layout for different DataType
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        var adjustedIndex = indexPath.row
        if let d = delegate {
            adjustedIndex = indexPath.row - d.numberOfItemsInTopCollection()
            if indexPath.item < d.numberOfItemsInTopCollection() {
                cell.backgroundColor = UIColor.clear
            } else {
                switch dataItems[adjustedIndex] % 2 {
                case 0:
                    cell.backgroundColor = UIColor.gray
                    break
                case 1:
                    cell.backgroundColor = UIColor.black
                    break
                default:
                    cell.backgroundColor = UIColor.orange
                }
            }
        }
        
        return cell
    }
}

extension BottomCollectionDataSource: UICollectionViewDelegateFlowLayout {
    //MARK: Flow Layout Delegate

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
