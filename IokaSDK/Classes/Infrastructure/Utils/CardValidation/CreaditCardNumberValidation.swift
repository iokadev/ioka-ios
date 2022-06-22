//
//  CreaditCardNumberValidation.swift
//  CreditCardValidator
//
//  Created by ablai erzhanov on 23.05.2022.
//

import Foundation


public enum CreditCardType: String {
    case amex = "^3[47][0-9]{5,}$"
    case visa = "^4[0-9]{6,}$" //
    case masterCard = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$" //
    case maestro = "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$" //
    case dinersClub = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$" //
    case jcb = "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$" //
    case discover = "^6(?:011|5[0-9]{2})[0-9]{3,}$" //
    case unionPay = "^62[0-5]\\d{13,16}$"
    case mir = "^2[0-9]{6,}$"
//    case americanExpress = "^3[47][0-9]{13}$" //

    var validNumberLength: IndexSet {
        switch self {
        case .visa:
            return IndexSet([13,16])
        case .amex:
            return IndexSet(integer: 15)
        case .maestro:
            return IndexSet(integersIn: 12...19)
        case .dinersClub:
            return IndexSet(integersIn: 14...19)
        case .jcb, .discover, .unionPay, .mir:
            return IndexSet(integersIn: 16...19)
        default:
            return IndexSet(integer: 16)
        }
    }
}

public struct CreditCardValidatorr {

    /// Available credit card types
    private let types: [CreditCardType] = [
        .amex,
        .visa,
        .masterCard,
        .maestro,
        .dinersClub,
        .jcb,
        .discover,
        .unionPay,
        .mir,
//        .americanExpress
    ]

    static let typess: [CreditCardType] = [
        .amex,
        .visa,
        .masterCard,
        .maestro,
        .dinersClub,
        .jcb,
        .discover,
        .unionPay,
        .mir,
//        .americanExpress
    ]

    let string: String

    /// Create validation value
    /// - Parameter string: credit card number
    public init(_ string: String) {
        self.string = string.numbers
    }

    /// Get card type
    /// Card number validation is not perfroms here
    public var type: CreditCardType? {
        types.first { type in
            NSPredicate(format: "SELF MATCHES %@", type.rawValue)
                .evaluate(
                    with: string.numbers
                )
        }
    }

    /// Calculation structure
    private struct Calculation {
        let odd, even: Int
        func result() -> Bool {
            (odd + even) % 10 == 0
        }
    }

    /// Validate credit card number
    public var isValid: Bool {
        guard let type = type else { return false }
        let isValidLength = type.validNumberLength.contains(string.count)
        return isValidLength
    }

    /// Validate card number string for type
    /// - Parameters:
    ///   - string: card number string
    ///   - type: credit card type
    /// - Returns: bool value
    public func isValid(for type: CreditCardType) -> Bool {
        isValid && self.type == type
    }

    static public func detectType(partialBin: String) -> CreditCardType? {
        return  CreditCardValidatorr.typess.first { type in
            NSPredicate(format: "SELF MATCHES %@", type.rawValue)
                .evaluate(
                    with: partialBin.numbers
                )
        }
    }

    static func getPaymentSystemLength(newLength: Int, paymentSystem: PaymentSystem?) -> Bool {
        switch paymentSystem {
        case .AMERICAN_EXPRESS:
            return newLength <= 18
        case .DINER_CLUB, .MAESTRO, .JCB, .DISCOVERY, .UNION_PAY, .MIR:
            return newLength <= 23
        default :
            return newLength <= 19
        }
    }

    /// Validate string for credit card type
    /// - Parameters:
    ///   - string: card number string
    /// - Returns: bool value
    private func isValid(for string: String) -> Bool {
        string
            .reversed()
            .compactMap({ Int(String($0)) })
            .enumerated()
            .reduce(Calculation(odd: 0, even: 0), { value, iterator in
                return .init(
                    odd: odd(value: value, iterator: iterator),
                    even: even(value: value, iterator: iterator)
                )
            })
            .result()
    }

    private func odd(value: Calculation, iterator: EnumeratedSequence<[Int]>.Element) -> Int {
        iterator.offset % 2 != 0 ? value.odd + (iterator.element / 5 + (2 * iterator.element) % 10) : value.odd
    }

    private func even(value: Calculation, iterator: EnumeratedSequence<[Int]>.Element) -> Int {
        iterator.offset % 2 == 0 ? value.even + iterator.element : value.even
    }

}

fileprivate extension String {

    var numbers: String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = components(separatedBy: set)
        return numbers.joined(separator: "")
    }

}

