//
//  ApplePayParameters.swift
//  Ioka
//
//  Created by ablai erzhanov on 13.05.2022.
//

import Foundation


struct CreatePaymentTokenParameters: Codable {
    var tool_type: String = "APPLE_PAY"
    var apple_pay: ApplePayParameters
}

struct ApplePayParameters: Codable {
    var paymentData: ApplePayPaymentData
    var paymentMethod: ApplePayPaymentMethod
    var transactionIdentifier: String
}

extension ApplePayParameters {
    static var defaultValue = ApplePayParameters(paymentData: ApplePayPaymentData(data: "4ZlLTN/GhrRitlzFbGnDdsuu3a4mTjBZRXptYATIQoCIalK7hJQAHBJcqkfQdnKCUnLAbxg310Vm0obyuguFQIeczzVkH+lo9N2UIHwhDlFlTR+nNslBoobHqfziSRldw4avfmaTmwHWNPRV85C0FbZ5YhaLLtypUBFZeEl/TS9Sx7afFHU91JtR+Yj54cH47+6jRNZ5eiodM+HamT5lIdIaYB7HJ26CZphrU2ZE0Okhj5vSmK9ZySsHKUrylyeQ9oZwEEWIk+89MImo6CL/XM5eFQ4SLqukEBan1v137vLytBCIIPNRGMg2TJ+x1Iq8JYSuqTTQ==Hex5x4g2lAfW3yV5EFAiCq7tPNiaBeefol4Z6G8Bs4urIKoLZpenU/2F+bcKgC5yjEIMxvjNuL3/SNP8PLgbZmtjbesD1LJB7K",
                                                                                  header: PaymentDataHeader(
                                                                                    ephemeralPublicKey: "MFkwEwYHKoZIzj0CAQYIKoZIzdjnxsbiDQgAExAmksc2dq3vOruObvmTF8C7IlBx8BCfyCArAjaYmkZUMKhWHWPtpC3IMDofKiuzOtVVi2VvuNsfxZaUdllYE7Q==",
                                                                                    publicKeyHash: "Dk6svUSoQoWogdiXM6yN6LqrE+kRgr4V9klAMhoViTM=",
                                                                                    transactionId: "6e6c55ff714e956f2f0bb11fcea9a1c3e536f83b749d7fbb255cc10893816b93"),
                                                                                  signature: "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",
                                                                                  version: "EC_v1"),
                                                 paymentMethod: ApplePayPaymentMethod(displayName: "Visa 1111",
                                                                                      network: "Visa",
                                                                                      type: "debit"),
                                                 transactionIdentifier: "6E6C55FF714E956F2F0BB11FCEA9AC10893816B93")
}

struct ApplePayPaymentData: Codable {
    var data: String
    var header: PaymentDataHeader
    var signature: String
    var version: String
}

struct PaymentDataHeader: Codable {
    var ephemeralPublicKey: String
    var publicKeyHash: String
    var transactionId: String
}

struct ApplePayPaymentMethod: Codable {
    var displayName: String
    var network: String
    var type: String
}
