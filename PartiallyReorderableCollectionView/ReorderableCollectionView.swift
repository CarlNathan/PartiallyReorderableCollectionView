//
//  ReorderableCollectionView.swift
//  PartiallyReorderableCollectionView
//
//  Created by Carl Udren on 1/3/17.
//  Copyright © 2017 Carl Udren. All rights reserved.
//

import Foundation
import UIKit

protocol ReorderableCollectionViewDelegate {
    func topCollectionDidSelectItemAt(_ indexPath: IndexPath)
}

class ReorderableCollectionView: UIView {
    
    var bottomCollection: UICollectionView!
    var topCollection: TouchTransparentCollectionView!
    let dataSource = ReorderableCollectionViewDataSource()
    var delegate: ReorderableCollectionViewDelegate?
    
    var longPressGesture: UILongPressGestureRecognizer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDataSourceDelegate()
        prepareBottomCollection()
        prepareTopCollection()
        prepareLongGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDataSourceDelegate()
        prepareBottomCollection()
        prepareTopCollection()
        prepareLongGesture()
    }
    
    internal func setDataSourceDelegate() {
        dataSource.delegate = self
    }
    
    internal func prepareBottomCollection() {
        let layout = UICollectionViewFlowLayout()
        
        
        bottomCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        bottomCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        bottomCollection.dataSource = dataSource.bottomDataSource
        bottomCollection.delegate = dataSource.bottomDataSource
        bottomCollection.backgroundColor = UIColor.white
        
        addSubview(bottomCollection)
    }
    
    internal func prepareTopCollection() {
        let layout = TopCollectionFlowLayout(bottomCollectionFlowLayout: bottomCollection.collectionViewLayout as! UICollectionViewFlowLayout)
        
        
        topCollection = TouchTransparentCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        topCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        topCollection.dataSource = dataSource.topDataSource
        topCollection.delegate = dataSource.topDataSource
        topCollection.backgroundColor = UIColor.clear
        
        
        addSubview(topCollection)
    }
    
    internal func prepareLongGesture() {
        let longPressGesture =  UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        topCollection.addGestureRecognizer(longPressGesture)
    }
    
    override func layoutSubviews() {
        layoutBottomCollection()
        layoutTopCollection()
    }
    
    internal func layoutBottomCollection() {
        bottomCollection.frame = bounds
    }
    
    internal func layoutTopCollection() {
        topCollection.frame = bounds
    }
    

    
    internal func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState .began:
            guard let selectedIndexPath = self.topCollection.indexPathForItem(at: gesture.location(in: self.topCollection)) else {
                break
            }
            topCollection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState .changed:
            topCollection.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState .ended:
            topCollection.endInteractiveMovement()
        default:
            topCollection.cancelInteractiveMovement()
        }
    }
    
    func addItems(items: [UIColor]) {
        dataSource.topDataSource.add(items)
        topCollection.performBatchUpdates({
            for _ in items {
                self.topCollection.insertItems(at: [IndexPath(row: 0, section: 0)])
            }
        }, completion: nil)
        bottomCollection.performBatchUpdates({
            for _ in items {
                self.bottomCollection.insertItems(at: [IndexPath(row: 0, section: 0)])
            }
        }, completion: nil)
        //topCollection.reloadData()
        //bottomCollection.reloadData()
    }
    
    func removeItemsAt(_ indexPaths: [IndexPath]) {
        dataSource.topDataSource.removeItemsAt(indexPaths)
        topCollection.performBatchUpdates({
            self.topCollection.deleteItems(at: indexPaths)
        }, completion: nil)
        bottomCollection.performBatchUpdates({
            self.bottomCollection.deleteItems(at: indexPaths)
        }, completion: nil)
    }
    
}

extension ReorderableCollectionView: ReforderableCollectionViewDataSourceDelegate {
    
    func topCollectionDidSelectItemAt(_ indexPath: IndexPath) {
        if let d = delegate {
            d.topCollectionDidSelectItemAt(indexPath)
        }
    }
    
    func topScrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomCollection.contentOffset = scrollView.contentOffset
    }
    
    func bottomScrollViewDidScroll(_ scrollView: UIScrollView) {
        topCollection.contentOffset = scrollView.contentOffset
    }
}
