import Foundation

internal struct Order {
    let id: String
    var externalId: String?
    var hasCustomerId: Bool
    var price: Int
    var currency: String
    var amount: Int
}
