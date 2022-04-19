//
//  SavedCardsViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 16.03.2022.
//

import Foundation
import UIKit
import Ioka

internal class SavedCardsViewController: UIViewController {
    
    var models = [SavedCard]()
    
    var closeButton = DemoButton(imageName: "chevronLeft", backGroundColor: .clear)
    var titleLabel = DemoLabel(title: "Способ оплаты", font: typography.title, textColor: colors.text, textAlignment: .center)
    let tableView = UITableView()
    let backgroundView = DemoCustomView(backGroundColor: colors.tertiaryBackground, cornerRadius: 8)
    var customerAccessToken: String!
    let viewModel = SavedCardsViewModel()
    let resultView = DemoAppErrorView()
    var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colors.secondaryBackground
        [closeButton, titleLabel, tableView].forEach {
            self.view.addSubview($0)
        }
        
        tableView.backgroundColor = colors.quaternaryBackground
        tableView.layer.cornerRadius = 12
        
        setUpTableView()
        setupActions()
        setupUI()
        updateSavedCards()
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
        tableView.rowHeight = 56
        tableView.register(AddNewCardTableViewCell.self, forCellReuseIdentifier: AddNewCardTableViewCell.cellId)
        tableView.register(GetCardTableViewCell.self, forCellReuseIdentifier: GetCardTableViewCell.cellId)
    }
    
    private func setupActions() {
        self.closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    }
    
    @objc private func handleCloseButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        closeButton.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, paddingTop: 60, paddingLeft: 16, width: 24, height: 24)
        titleLabel.center(in: self.view, in: closeButton)
        tableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 116, paddingLeft: 16, paddingRight: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 56)
        self.heightConstraint?.isActive = true
    }
    
    private func updateSavedCards() {
        viewModel.getCards(customerAccessToken: customerAccessToken) { [weak self] result in
            guard let models = result else { return }
            self?.models.append(contentsOf: models)
            self?.updateTableViewHeight()
            self?.tableView.reloadData()
        }
    }
    
    private func updateTableViewHeight() {
        heightConstraint?.constant = CGFloat(56 * models.count) + 56
        view.layoutIfNeeded()
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
    func deleteCard(_ view: GetCardTableViewCell, card: SavedCard) {
        let vc = DeleteSavedCardViewController()
        vc.card = card
        vc.delegate = self
        vc.customerAccessToken = customerAccessToken
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    func viewTapped(_ view: AddNewCardTableViewCell) {
        Ioka.shared.startSaveCardFlow(sourceViewController: self, customerAccessToken: customerAccessToken) { [weak self] result in
            if result == .succeeded {
                self?.updateSavedCards()
            }
        }
    }
}

extension SavedCardsViewController: DeleteSavedCardViewControllerDelegate, DemoAppErrorViewDelegate {
    
    func closeErrorView(_ view: DemoAppErrorView) {
        resultView.removeFromSuperview()
    }
    
    func closeDeleteCardViewController(_ viewController: UIViewController, card: SavedCard, error: Error?) {
        switch error {
        case .some(let error):
            resultView.error = error
            resultView.delegate = self
            self.view.addSubview(resultView)
            resultView.anchor(left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 16, paddingBottom: 58, paddingRight: 16)
        case .none:
            self.models.removeAll { $0.id == card.id}
            updateTableViewHeight()
            self.tableView.reloadData()
        }
       
    }
    
    
}
