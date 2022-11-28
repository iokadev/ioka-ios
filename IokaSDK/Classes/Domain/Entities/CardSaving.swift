import Foundation

internal struct CardSaving {
    enum Status {
        case succeeded
        case declined(APIError)
        case requiresAction(Action)
    }
    
    let status: Status
    let id: String
}
