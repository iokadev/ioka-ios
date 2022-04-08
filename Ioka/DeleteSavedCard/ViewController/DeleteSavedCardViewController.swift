//
//  DeleteSavedCardViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 30.03.2022.
//

import UIKit


internal protocol DeleteSavedCardViewControllerDelegate: NSObject {
    func closeDeleteCardViewController(_ viewController: UIViewController, card: GetCardResponse, error: IokaError?)
}

internal class DeleteSavedCardViewController: UIViewController {
    
    let deleteView = DeleteSavedCardView()
    var card: GetCardResponse!
    var customerAccessToken: String!
    weak var delegate: DeleteSavedCardViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(deleteView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteView.configuredeleteCardView(card: card)
        deleteView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        deleteView.fillView(self.view)
    }
}

extension DeleteSavedCardViewController: DeleteSavedCardViewDelegate {
    func closeDeleteSavedCardView(_ view: DeleteSavedCardView) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func deleteSavedCard(_ view: DeleteSavedCardView) {
        self.dismiss(animated: false, completion: nil)
        
        Ioka.shared.deleteSavedCard(customerAccessToken: customerAccessToken, cardId: card.id) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate?.closeDeleteCardViewController(self, card: self.card, error: error)
            case .success( _):
                self.delegate?.closeDeleteCardViewController(self, card: self.card, error: nil)
            }
        }
    }
}
