//
//  FilterVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func btnBackClicked(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}
