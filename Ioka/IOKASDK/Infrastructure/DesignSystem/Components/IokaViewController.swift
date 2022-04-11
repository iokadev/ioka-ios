//
//  IokaViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 31.03.2022.
//

import UIKit


internal class IokaViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
}
