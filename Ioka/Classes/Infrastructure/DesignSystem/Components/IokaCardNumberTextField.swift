//
//  CustomCardNumberTextField.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import UIKit

internal protocol IokaCardNumberTextFieldDelegate: NSObject {
    func scannerDidPressed(_ textField: IokaCardNumberTextField)
}

internal class IokaCardNumberTextField: IokaTextField {
    let iconContainerView: UIView = {
        let view = UIView()
        view.frame =  CGRect(x: -40, y: 0, width: 40, height: 56)
        view.backgroundColor = .clear

        return view
    }()

    let cardBrandImageView = IokaImageView(frame: CGRect(x: -76, y: 16, width: 24, height: 24))
    let bankEmitterImageView = IokaImageView(frame: CGRect(x: -104, y: 16, width: 24, height: 24))
    let cardScannerImageView = IokaImageView(frame: CGRect(x: -40, y: 16, width: 24, height: 24))
    var isCardBrandSetted: Bool = false
    var isBankEmitterSetted: Bool = false
    weak var scannerDelegate: IokaCardNumberTextFieldDelegate?

    init() {
        super.init(inputType: .cardNumber)
        setUI()
        setActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setActions() {
        cardScannerImageView.isUserInteractionEnabled = true
        self.iconContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCardScannerTap)))
    }

    @objc private func handleCardScannerTap() {
        scannerDelegate?.scannerDidPressed(self)
    }

    private func setUI() {
        self.rightView = iconContainerView
        rightViewMode = .always
        cardBrandImageView.contentMode = .scaleAspectFit
        cardScannerImageView.contentMode = .scaleAspectFit
        bankEmitterImageView.contentMode = .scaleAspectFit
        if #available(iOS 13.0, *) {
            setCardScannerIcon()
        }
    }

    func setCardScannerIcon() {
        guard let image = UIImage(named: "scanner", in: IokaBundle.bundle, compatibleWith: nil) else { return }
        cardScannerImageView.image = image
        self.addSubview(cardScannerImageView)
        cardScannerImageView.centerY(in: self, right: self.rightAnchor, paddingRight: 16, width: 24, height: 24)
    }

    func setCardBrandIcon(imageName: String) {
        guard let image = UIImage(named: imageName, in: IokaBundle.bundle, compatibleWith: nil) else { return }
        cardBrandImageView.image = image

        self.addSubview(cardBrandImageView)
        cardBrandImageView.centerY(in: self, right: cardScannerImageView.leftAnchor, paddingRight: 12, width: 24, height: 24)

        self.isCardBrandSetted = true
    }

    func setBankEmitterIcon(imageName: String) {
        guard let image = UIImage(named: imageName, in: IokaBundle.bundle, compatibleWith: nil) else { return }
        bankEmitterImageView.image = image
        self.addSubview(bankEmitterImageView)
        bankEmitterImageView.centerY(in: self, right: cardBrandImageView.leftAnchor, paddingRight: 4, width: 24, height: 24)
        self.isBankEmitterSetted = true
    }
}
