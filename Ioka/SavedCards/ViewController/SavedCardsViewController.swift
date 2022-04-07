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
    let backgroundView = IokaCustomView(backGroundColor: DemoAppColors.tertiaryBackground, cornerRadius: 8)
    var customerAccessToken: String!
    let viewModel = SavedCardsViewModel()
    let resultView = DemoAppErrorView()
    var heightConstraint: NSLayoutConstraint?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = DemoAppColors.secondaryBackground
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 12
    }
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
    }
}


extension SavedCardsViewController: AddNewCardTablewViewCellDelegate, GetCardTableViewCellDelegate {
    func deleteCard(_ view: GetCardTableViewCell, card: GetCardResponse) {
        let vc = DeleteSavedCardViewController()
        vc.card = card
        vc.delegate = self
        vc.customerAccessToken = customerAccessToken
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    func viewTapped(_ view: AddNewCardTableViewCell) {
        Ioka.shared.startSaveCardFlow(viewController: self, customerAccessToken: customerAccessToken)
    }
}

extension SavedCardsViewController: DeleteSavedCardViewControllerDelegate, DemoAppErrorViewDelegate {
    
    func closeErrorView(_ view: DemoAppErrorView) {
        resultView.removeFromSuperview()
    }
    
    func closeDeleteCardViewController(_ viewController: UIViewController, card: GetCardResponse, error: IokaError?) {
        resultView.error = error
        resultView.delegate = self
        self.view.addSubview(resultView)
        resultView.anchor(left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 16, paddingBottom: 58, paddingRight: 16)
    }
    
    
}
