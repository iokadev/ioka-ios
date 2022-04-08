//
//  PaymentTypeViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 13.03.2022.
//

import UIKit

import UIKit

protocol PaymentTypeViewControllerDelegate: NSObject {
    func popPaymentViewController(_ paymentTypeViewController: PaymentTypeViewController, state: PaymentTypeState)
}

class PaymentTypeViewController: UIViewController {
    
    let contentView = PaymentTypeView()
    let viewModel = PaymentTypeViewModel()
    var customerAccessToken: String!
    var models = [GetCardResponse]()
    weak var delegate: PaymentTypeViewControllerDelegate?
    
    
    override func loadView() {
        super.loadView()
        self.view = contentView
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(ApplePayCell.self, forCellReuseIdentifier: ApplePayCell.cellId)
        contentView.tableView.register(CardPaymentCell.self, forCellReuseIdentifier: CardPaymentCell.cellId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        contentView.setupUI(models: models)
        viewModel.getCards(customerAccessToken: customerAccessToken) { result, error in
            guard let models = result else { return }
            self.models.append(contentsOf: models)
            self.contentView.reloadTableView(models: models)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}


extension PaymentTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ApplePayCell.cellId, for: indexPath) as? ApplePayCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configure(delegate: contentView)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardPaymentCell.cellId, for: indexPath) as? CardPaymentCell else { return UITableViewCell() }
            cell.configure(model: self.models[indexPath.row - 1], delegate: contentView)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PaymentTypeViewController: PaymentTypeViewDelegate {
    func saveButtonWasPressed(_ paymentTypeView: PaymentTypeView, state: PaymentTypeState) {
        delegate?.popPaymentViewController(self, state: state)
        self.navigationController?.popViewController(animated: true)
    }
}
