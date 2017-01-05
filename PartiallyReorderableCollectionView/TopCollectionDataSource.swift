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
    
    //MARK: Properties
    
    public var delegate: TopDataSourceDelegate?
    //FIXME: Change DataType
    public var dataItems = [UIColor.blue, UIColor.green, UIColor.red, UIColor.cyan, UIColor.brown]
    
    public func numberOfItems() -> Int {
        return dataItems.count
    }
    
    //MARK: Add/Remove Items
    
    //FIXME: Integrate change data type
    public func add(_ items: [UIColor]) {
        for item in items {
            dataItems.insert(item, at: 0)
        }
    }
    
    public func removeItemsAt(_ indexPaths: [IndexPath]) {
        var indicesToBeRemoved = Set<Int>()
        for indexPath in indexPaths {
            indicesToBeRemoved.update(with: indexPath.row)
        }
        dataItems = dataItems.enumerated().filter({ !indicesToBeRemoved.contains($0.offset) }).map { $0.element }
    }
    
}


extension TopCollectionDataSource: UICollectionViewDataSource {
    //MARK: CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }
    //FIXME: Change Cell setup for new data Type
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = dataItems[indexPath.row]
        return cell
    }
}

extension TopCollectionDataSource: UICollectionViewDelegate {
    //MARK: CollectionView Delegate

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //FIXME: Update data on reordering
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
