#if os(iOS)

import UIKit

public final class RangeMarkerType: NSObject, NSCopying {
    var name: String?
    var scale: Float = 1
    var size = CGSize(width: 2.0, height: 10.0)
    var labelVisible: Bool = true
    var color: UIColor = .white
    var font: UIFont = UIFont.systemFont(ofSize: 10)

    public convenience init(
        color: UIColor,
        size: CGSize,
        scale: Float
    ) {
        self.init()
        self.color = color
        self.size = size
        self.scale = scale
    }

    public class func largestScale(types: [RangeMarkerType]?) -> Float {
        var largestScale = Float.leastNormalMagnitude
        if let types = types {
            for type in types {
                largestScale = fmax(type.scale, largestScale)
            }
        }
        return largestScale
    }

    public class func minScale(types: [RangeMarkerType]?) -> Float {
        var minScale = Float.greatestFiniteMagnitude
        if let types = types {
            for type in types {
                minScale = fmin(type.scale, minScale)
            }
        }
        return minScale
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = RangeMarkerType()
        copy.name = self.name
        copy.scale = self.scale
        copy.size = self.size
        copy.color = self.color
        copy.font = self.font
        return copy
    }
}

#endif
