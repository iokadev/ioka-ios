import Foundation

/// Сохраненная карта пользователя
public struct SavedCard {
    /// id сохраненной карты. Используется для удаления карты и для оплаты.
    public let id: String
    /// Маскированный PAN карты в формате "555555******5599"
    public let maskedPAN: String
    /// Срок действия карты в формате "12/24"
    public let expirationDate: String?
    
    let paymentSystem: String?
    let emitter: String?
    let cvvIsRequired: Bool
    
    /// Иконка платёжной системы карты (Visa, Mastercard или др.). Рекомендуемый размер UIImageView - 24x24.
    public var paymentSystemIcon: UIImage? {
        guard let paymentSystem = paymentSystem else {
            return nil
        }
        
        return UIImage(named: paymentSystem, in: IokaBundle.bundle, compatibleWith: nil)
    }
    
    /// Иконка банка-эмитента карты. Рекомендуемый размер UIImageView - 24x24.
    public var emitterIcon: UIImage? {
        guard let emitter = emitter else {
            return nil
        }
        
        return UIImage(named: emitter, in: IokaBundle.bundle, compatibleWith: nil)
    }
}
