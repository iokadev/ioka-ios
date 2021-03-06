//
//  MainViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 09.03.2022.
//

import Foundation
import UIKit


internal class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let models = OrderModel.models
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let goConfitmationButton = DemoButton(title: "Перейти к оформлению")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setUI()
        setActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Корзина"
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.cellId)
    }
    
    private func setActions() {
        self.goConfitmationButton.addTarget(self, action: #selector(handleConfirmationButton), for: .touchUpInside)
    }
    
    @objc private func handleConfirmationButton() {
        self.title = ""
        let vc = OrderConfirmationViewController()
        vc.order = models[0]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUI() {
        view.backgroundColor = colors.tertiaryBackground
        [tableView, goConfitmationButton].forEach { self.view.addSubview($0) }
        
        tableView.fillView(self.view)
        
        goConfitmationButton.anchor(left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 16, paddingBottom: 106, paddingRight: 16, height: 56)
        
        view.bringSubviewToFront(goConfitmationButton)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cellId, for: indexPath) as? ProductCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.configure(model: models[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
