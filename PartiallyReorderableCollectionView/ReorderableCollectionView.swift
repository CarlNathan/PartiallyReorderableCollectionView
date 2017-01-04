//
//  ReorderableCollectionView.swift
//  PartiallyReorderableCollectionView
//
//  Created by Carl Udren on 1/3/17.
//  Copyright © 2017 Carl Udren. All rights reserved.
//

import Foundation
import UIKit

class ReorderableCollectionView: UIView {
    
    var bottomCollection: UICollectionView!
    var topCollection: TouchTransparentCollectionView!
    let dataSource = ReorderableCollectionViewDataSource()
    
    var longPressGesture: UILongPressGestureRecognizer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDataSourceDelegate()
        prepareBottomCollection()
        prepareTopCollection()
        prepareLongGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSourceDelegate() {
        dataSource.delegate = self
    }
    
    func prepareBottomCollection() {
        let layout = UICollectionViewFlowLayout()
        
        
        bottomCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        bottomCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        bottomCollection.dataSource = dataSource.bottomDataSource
        bottomCollection.delegate = dataSource.bottomDataSource
        bottomCollection.backgroundColor = UIColor.white
        
        addSubview(bottomCollection)
    }
    
    func prepareTopCollection() {
        let layout = TopCollectionFlowLayout(bottomCollectionFlowLayout: bottomCollection.collectionViewLayout as! UICollectionViewFlowLayout)
        
        
        topCollection = TouchTransparentCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        topCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        topCollection.dataSource = dataSource.topDataSource
        topCollection.delegate = dataSource.topDataSource
        topCollection.backgroundColor = UIColor.clear
        
        
        addSubview(topCollection)
    }
    
    func prepareLongGesture() {
        let longPressGesture =  UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        topCollection.addGestureRecognizer(longPressGesture)
    }
    
    override func layoutSubviews() {
        layoutBottomCollection()
        layoutTopCollection()
    }
    
    func layoutBottomCollection() {
        bottomCollection.frame = bounds
    }
    
    func layoutTopCollection() {
        topCollection.frame = bounds
    }
    

    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
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
    
}

extension ReorderableCollectionView: ReforderableCollectionViewDataSourceDelegate {
    
    func topScrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomCollection.contentOffset = scrollView.contentOffset
    }
    
    func bottomScrollViewDidScroll(_ scrollView: UIScrollView) {
        topCollection.contentOffset = scrollView.contentOffset
    }
}
