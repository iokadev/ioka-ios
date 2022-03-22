//
//  PaymentTypeViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 13.03.2022.
//

import UIKit

protocol PaymentTypeViewControllerDelegate: NSObject {
    func popPaymentViewController(_ paymentTypeViewController: PaymentTypeViewController, state: PaymentTypeState)
}

class PaymentTypeViewController: UIViewController {
    
    var models: [GetCardResponse]!
    let contentView = PaymentTypeView()
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
        contentView.setupUI(models: models)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
    func saveButtonWasPressed(_ paymentTypeView: PaymentTypeView) {
        delegate?.popPaymentViewController(self, state: .creditCard)
        self.navigationController?.popViewController(animated: true)
    }
}
