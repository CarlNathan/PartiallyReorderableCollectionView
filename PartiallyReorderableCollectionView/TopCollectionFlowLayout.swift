//
//  TopCollectionFlowLayout.swift
//  PartiallyReorderableCollectionView
//
//  Created by Carl Udren on 1/4/17.
//  Copyright © 2017 Carl Udren. All rights reserved.
//

import Foundation
import UIKit

class TopCollectionFlowLayout: UICollectionViewFlowLayout {
    
    internal let bottomCollectionLayout: UICollectionViewFlowLayout
    
    init(bottomCollectionFlowLayout: UICollectionViewFlowLayout) {
        self.bottomCollectionLayout = bottomCollectionFlowLayout
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        return bottomCollectionLayout.collectionViewContentSize
    }
    
}
