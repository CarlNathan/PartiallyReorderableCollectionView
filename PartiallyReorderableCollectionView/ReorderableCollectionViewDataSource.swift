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
    func bottomScrollViewDidScroll(_ scrollView: UIScrollView)
}

protocol TopDataSourceDelegate {
    func topScrollViewDidScroll(_ scrollView: UIScrollView)
}

protocol ReforderableCollectionViewDataSourceDelegate {
    func topScrollViewDidScroll(_ scrollView: UIScrollView)
    func bottomScrollViewDidScroll(_ scrollView: UIScrollView)
}

class ReorderableCollectionViewDataSource: NSObject {
    
    let topDataSource = TopCollectionDataSource()
    let bottomDataSource = BottomCollectionDataSource()
    var delegate: ReforderableCollectionViewDataSourceDelegate?
    
    override init() {
        super.init()
        topDataSource.delegate = self
        bottomDataSource.delegate = self
    }
    
}

extension ReorderableCollectionViewDataSource: BottomDataSourceDelegate {
    internal func numberOfItemsInTopCollection() -> Int {
        return topDataSource.numberOfItems()
    }
    
    func bottomScrollViewDidScroll(_ scrollView: UIScrollView) {
        if let d = delegate {
            d.bottomScrollViewDidScroll(scrollView)
        }
    }
}

extension ReorderableCollectionViewDataSource: TopDataSourceDelegate {
    
    func topScrollViewDidScroll(_ scrollView: UIScrollView) {
        if let d = delegate {
            d.topScrollViewDidScroll(scrollView)
        }
    }
}
