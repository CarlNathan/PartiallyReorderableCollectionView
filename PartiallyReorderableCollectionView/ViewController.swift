//
//  ViewController.swift
//  PartiallyReorderableCollectionView
//
//  Created by Carl Udren on 1/3/17.
//  Copyright © 2017 Carl Udren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var reoderCollectionView: ReorderableCollectionView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reoderCollectionView.delegate = self
        view.addSubview(reoderCollectionView)
        setupNavButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        navigationItem.rightBarButtonItem = button
    }
    
    func addNewItem() {
        let colors = [UIColor.darkGray, UIColor.orange]
        reoderCollectionView.addItems(items: colors)
    }


}

extension ViewController: ReorderableCollectionViewDelegate {
    func topCollectionDidSelectItemAt(_ indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Delete Image", message: "Would you like to delete the image you selected?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            //dismiss
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.reoderCollectionView.removeItemAt(indexPath)
        }
        alertController.addAction(OKAction)
        
        navigationController?.present(alertController, animated: true) {
            
        }

    }
}

