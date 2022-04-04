//
//  DeleteSavedCardViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 30.03.2022.
//

import UIKit


protocol DeleteSavedCardViewControllerDelegate: NSObject {
    func closeDeleteCardViewController(_ viewController: UIViewController, card: GetCardResponse, error: IokaError?)
}

class DeleteSavedCardViewController: UIViewController {
    
    let deleteView = DeleteSavedCardView()
    var card: GetCardResponse!
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
        IOKA.shared.deleteSavedCard(customerId: card.customer_id, cardId: card.id) { error in
            DispatchQueue.main.async {
                self.delegate?.closeDeleteCardViewController(self, card: self.card, error: error)
                
            }
        }
    }
}
