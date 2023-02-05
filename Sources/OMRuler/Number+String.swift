import Foundation

extension Int {
    func addLeadingZeroAsString() -> String {
        return String(format: "%02d", self)  // add leading zero to single digit
    }

  func addFirstLeadingZeroAsString() -> String {
        return String(format: "%01d", self)  // add leading zero to single digit
    }
}

extension Double {

    func stripDecimalZeroAsString() -> String? {
        if self >= 1 || self == 0 {
            return nil
        }
        let formatter = NumberFormatter()
        formatter.positiveFormat = ".###" // decimal without decimal 0

        return formatter.string(from: self as NSNumber) // 0.333454 becomes ".333"
    }
}
