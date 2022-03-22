//
//  MainViewController.swift
//  iOKA
//
//  Created by ablai erzhanov on 09.03.2022.
//

import Foundation
import UIKit


class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let models = OrderModel.models
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = IokaColors.fill5
        return tableView
    }()
    
    let goConfitmationButton = IokaButton(iokaButtonState: .enabled, title: "Перейти к оформлению", image: nil)
    
    
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
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.961, alpha: 1)
        
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(goConfitmationButton)
        goConfitmationButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(106)
        }
        
        view.bringSubviewToFront(goConfitmationButton)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.cellId, for: indexPath) as? ProductCell else { return UITableViewCell() }
        cell.configure(model: models[indexPath.row])
        cell.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.961, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
