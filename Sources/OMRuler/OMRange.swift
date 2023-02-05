import Foundation

public final class OMRange<T>: NSObject {
    public var location: T
    public var length: T

    public init(location: T, length: T) {
        self.location = location
        self.length = length
        super.init()
    }

    public override var description: String {
        String("location: \(location) length: \(self.length)")
    }
}
