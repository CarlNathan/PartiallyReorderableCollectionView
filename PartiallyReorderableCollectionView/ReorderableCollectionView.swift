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
    //MARK: Properties
    internal var bottomCollection: UICollectionView!
    internal var topCollection: UICollectionView!
    //FIXME: Probably need to change initialization of data sources to inject data
    public let dataSource = ReorderableCollectionViewDataSource()
    public var delegate: ReorderableCollectionViewDelegate?
    
    internal var longPressGesture: UILongPressGestureRecognizer!
    
    //MARK: Initialization
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
        //FIXME: Change cell type if using custom class
        bottomCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        bottomCollection.dataSource = dataSource.bottomDataSource
        bottomCollection.delegate = dataSource.bottomDataSource
        bottomCollection.backgroundColor = UIColor.white
        
        addSubview(bottomCollection)
    }
    
    internal func prepareTopCollection() {
        let layout = TopCollectionFlowLayout(bottomCollectionFlowLayout: bottomCollection.collectionViewLayout as! UICollectionViewFlowLayout)
        
        
        topCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //FIXME: Change cell type if using custom class
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
    //MARK: Layout
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
    

    //MARK: Reorder Gesture Handling
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
    //MARK: Add/Remove Items
    //FIXME: Implementation - Change Data Type
    public func addItems(items: [UIColor]) {
        dataSource.topDataSource.add(items)
        var indexPaths = [IndexPath]()
        for i in 0...items.count - 1 {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        topCollection.performBatchUpdates({
            self.topCollection.insertItems(at: indexPaths)
        }, completion: nil)
        bottomCollection.performBatchUpdates({
            for _ in items {
                self.bottomCollection.insertItems(at: [IndexPath(row: 0, section: 0)])
            }
        }, completion: nil)
    }
    
    public func removeItemsAt(_ indexPaths: [IndexPath]) {
        dataSource.topDataSource.removeItemsAt(indexPaths)
        topCollection.performBatchUpdates({
            self.topCollection.deleteItems(at: indexPaths)
        }, completion: nil)
        bottomCollection.performBatchUpdates({
            self.bottomCollection.deleteItems(at: indexPaths)
        }, completion: nil)
    }
    
}

extension ReorderableCollectionView: ReorderableCollectionViewDataSourceDelegate {
    //MARK: Reorderable DataSource Delegate
    func topCollectionDidSelectItemAt(_ indexPath: IndexPath) {
        if let d = delegate {
            d.topCollectionDidSelectItemAt(indexPath)
        }
    }
    
    func topScrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomCollection.contentOffset = scrollView.contentOffset
    }
}
