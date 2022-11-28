import Foundation

internal enum DomainError: LocalizedError {
    case invalidTokenFormat
    case invalidPaymentStatus
    case noErrorForDeclinedStatus
    case noActionForRequiresActionStatus
    case invalidActionUrl
    
    var errorDescription: String? {
        IokaLocalizable.serverError
    }
}
