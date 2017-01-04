//
//  ViewController.swift
//  PartiallyReorderableCollectionView
//
//  Created by Carl Udren on 1/3/17.
//  Copyright © 2017 Carl Udren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let vw = ReorderableCollectionView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(vw)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        vw.frame = view.bounds
    }


}

