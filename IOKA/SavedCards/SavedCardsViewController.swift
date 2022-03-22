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
    let backgroundView = IokaCustomView(backGroundColor: IokaColors.fill6, cornerRadius: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = IokaColors.fill5
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(tableView)
        tableView.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddNewCardTableViewCell.self, forCellReuseIdentifier: AddNewCardTableViewCell.cellId)
    }
    
    private func setupUI() {
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(116)
            make.height.equalTo( models.count * 56 + 57)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SavedCardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if models.count == indexPath.row {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddNewCardTableViewCell.cellId, for: indexPath) as? AddNewCardTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GetCardTableViewCell.cellId, for: indexPath) as? GetCardTableViewCell else { return UITableViewCell() }
            cell.configure(model: self.models[indexPath.row])
            return cell
        }
    }
}
