//
//  ReorderableCollectionViewDataSource.swift
//  PartiallyReorderableCollectionView
//
//  Created by Carl Udren on 1/4/17.
//  Copyright © 2017 Carl Udren. All rights reserved.
//

import Foundation
import UIKit

protocol BottomDataSourceDelegate: UICollectionViewDelegate {
    func numberOfItemsInTopCollection() -> Int
}

protocol TopDataSourceDelegate {
    func topScrollViewDidScroll(_ scrollView: UIScrollView)
    func topCollectionDidSelectItemAt(_ indexPath: IndexPath)
}

protocol ReorderableCollectionViewDataSourceDelegate {
    func topScrollViewDidScroll(_ scrollView: UIScrollView)
    func topCollectionDidSelectItemAt(_ indexPath: IndexPath)
}

class ReorderableCollectionViewDataSource: NSObject {
    //MARK: Properties
    internal let topDataSource = TopCollectionDataSource()
    internal let bottomDataSource = BottomCollectionDataSource()
    public var delegate: ReorderableCollectionViewDataSourceDelegate?
    //Mark: Initialization
    override init() {
        super.init()
        topDataSource.delegate = self
        bottomDataSource.delegate = self
    }
    
}

extension ReorderableCollectionViewDataSource: BottomDataSourceDelegate {
    //MARK: Bottom Collection Data Delegate
    func numberOfItemsInTopCollection() -> Int {
        return topDataSource.numberOfItems()
    }
}

extension ReorderableCollectionViewDataSource: TopDataSourceDelegate {
    //MARK: Top Collection Data Delegate
    func topCollectionDidSelectItemAt(_ indexPath: IndexPath) {
        if let d = delegate {
            d.topCollectionDidSelectItemAt(indexPath)
        }
    }
    
    func topScrollViewDidScroll(_ scrollView: UIScrollView) {
        if let d = delegate {
            d.topScrollViewDidScroll(scrollView)
        }
    }
}
