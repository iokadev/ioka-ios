//
//  IokaViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 31.03.2022.
//

import UIKit


class IokaViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // REVIEW: зачем?
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // REVIEW: а если у мерчанта другие значения были?
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
}
