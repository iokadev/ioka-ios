//
//  DeleteSavedCardViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 30.03.2022.
//

import UIKit
import Ioka

internal protocol DeleteSavedCardViewControllerDelegate: NSObject {
    func closeDeleteCardViewController(_ viewController: UIViewController, card: SavedCardDTO, error: Error?)
}

internal class DeleteSavedCardViewController: UIViewController {
    
    let deleteView = DeleteSavedCardView()
    var card: SavedCardDTO!
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
        
        Ioka.shared.deleteSavedCard(customerAccessToken: customerAccessToken, cardId: card.id) {[weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.closeDeleteCardViewController(self, card: self.card, error: error)
            } else {
                self.delegate?.closeDeleteCardViewController(self, card: self.card, error: nil)
            }
        }
    }
}
