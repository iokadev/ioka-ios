//
//  UIViewController+NavigationItem.swift
//  Ioka
//
//  Created by Тимур Табынбаев on 18.04.2022.
//

import UIKit

extension UIViewController {
    func setupNavigationItem(title: String?, closeButtonTarget: Any?, closeButtonAction: Selector?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: IokaImages.close,
                                                           style: .plain,
                                                           target: closeButtonTarget,
                                                           action: closeButtonAction)
        
        guard let title = title else {
            return
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = typography.title
        titleLabel.textColor = colors.text
        navigationItem.titleView = titleLabel
    }
}
