//
//  SavedCardsViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit

class SavedCardsViewController: UIViewController {
    
    var models: [GetCardResponse] = []
    
    let tableView = UITableView()
    let backgroundView = IokaCustomView(backGroundColor: DemoAppColors.fill6, cornerRadius: 8)
    var customerAccessToken: String!
    let viewModel = SavedCardsViewModel()
    var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        viewModel.getCards(customerAccessToken: customerAccessToken) { [weak self] result in
            guard let models = result else { return }
            self?.models.append(contentsOf: models)
            self?.heightConstraint?.constant = CGFloat(56 * models.count) + 56
            self?.tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = DemoAppColors.fill5
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 12
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddNewCardTableViewCell.self, forCellReuseIdentifier: AddNewCardTableViewCell.cellId)
        tableView.register(GetCardTableViewCell.self, forCellReuseIdentifier: GetCardTableViewCell.cellId)
    }
    
    private func setupUI() {
        tableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 116, paddingLeft: 16, paddingRight: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.heightConstraint = tableView.heightAnchor.constraint(equalToConstant: CGFloat(56 * models.count) + 56)
        self.heightConstraint?.isActive = true
    }
}

extension SavedCardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if models.count == indexPath.row {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddNewCardTableViewCell.cellId, for: indexPath) as? AddNewCardTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GetCardTableViewCell.cellId, for: indexPath) as? GetCardTableViewCell else { return UITableViewCell() }
            cell.configure(model: self.models[indexPath.row])
            return cell
        }
    }
}


extension SavedCardsViewController: AddNewCardTablewViewCellDelegate {
    func viewTapped(_ view: AddNewCardTableViewCell) {
        IOKA.shared.startSaveCardFlow(viewController: self, customerAccessToken: customerAccessToken)
    }
}
