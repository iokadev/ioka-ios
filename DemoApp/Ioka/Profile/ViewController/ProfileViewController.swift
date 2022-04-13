//
//  ProfileViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import UIKit

internal class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.delegate = self
        profileView.update(locale: viewModel.locale)
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(profileView)
        profileView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func showSavedCard(_ profileView: ProfileView) {
        let vc = SavedCardsViewController()
        
        viewModel.getProfile { [weak self] customerAccessToken in
            vc.customerAccessToken = customerAccessToken
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showLanguageSelection(_ profileView: ProfileView) {
        let controller = UIAlertController(title: "Язык", message: nil, preferredStyle: .actionSheet)
        Locale.allCases.forEach { locale in
            controller.addAction(UIAlertAction(title: locale.label, style: .default) { [weak self] _ in
                self?.viewModel.locale = locale
                self?.profileView.update(locale: locale)
            })
        }
        
        controller.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(controller, animated: true, completion: nil)
    }
}
