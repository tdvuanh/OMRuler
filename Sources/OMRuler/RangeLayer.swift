#if os(iOS)

import UIKit

// MARK: - RangeLayer

public final class RangeLayer: CALayer {

    private lazy var markers: [RangeMarker] = prepareMarkers()

    // MARK: - Dependencies

    public var markerTypes = [RangeMarkerType]()

    public var distanceBetweenLeastScaleMarkers: Float?

    public var range: OMRange<Float> = OMRange<Float>(location: 0, length: 0) {
        didSet {
            if range.length != 0 {
                self.setNeedsDisplay()
            }
        }
    }

    // MARK: - Life Cycle

    public override var frame: CGRect {
        didSet {
            if oldValue != self.frame {
                self.markers = prepareMarkers()
                self.setNeedsDisplay()
            }
        }
    }

    public override func display() {
        super.display()

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.drawLayer()
        CATransaction.commit()
    }

    // MARK: - Private

    private func drawLayer() {
        guard let distanceBetweenLeastScaleMarkers = distanceBetweenLeastScaleMarkers else {
            fatalError("Please set distanceBetweenLeastScaleMarkers")
        }
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        var position: Float = 0

        var previousMarker: RangeMarker?

        if let context = UIGraphicsGetCurrentContext() {
            for marker in markers {
                if let previousMarker = previousMarker {
                    position += (marker.value - previousMarker.value) * distanceBetweenLeastScaleMarkers
                }

                self.drawMarker(marker, at: CGFloat(position), in: context)

                previousMarker = marker
            }

            if let imageToDraw = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext();
                imageToDraw.withRenderingMode(UIImage
                    .RenderingMode
                    .alwaysTemplate)
                contents = imageToDraw.cgImage
            }
        }
    }

    private func drawMarker(
        _ marker: RangeMarker,
        at position: CGFloat,
        in context: CGContext
    ) {
        let rangeEnd = fmax(self.range.location, self.range.location) + self.range.length

        let textAttributes = [
            NSAttributedString.Key.font: marker.type.font,
            NSAttributedString.Key.foregroundColor: marker.type.color
        ]
        let textSize = NSString(string: marker.text)
            .size(withAttributes: textAttributes)

        let xPos = position - marker.type.size.width / 2
        let yPos: CGFloat = 0

        let markerRect = CGRect(
            x: xPos,
            y: yPos,
            width: marker.type.size.width,
            height: marker.type.size.height)

        let textXPos = position
        let textYPos = textSize.height + marker.type.size.height

        let markerTextRect = CGRect(
            x: textXPos,
            y: textYPos - 8,
            width: textSize.width,
            height: textSize.height)

        context.setFillColor(UIColor.black.cgColor)
        context.fill(markerRect)

        if marker.value >= rangeEnd || marker.type.labelVisible {
            NSString(string: marker.text)
                .draw(in: markerTextRect, withAttributes: textAttributes)
        }
    }

    private func formatTimeString(time: Float) -> String {
        let second = Int(time.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)).addLeadingZeroAsString()
        let minute = Int(time.truncatingRemainder(dividingBy: 3600) / 60).addFirstLeadingZeroAsString()
        let hour = Int(time / 3600).addLeadingZeroAsString()
        if hour == "00" {
            return "\(minute):\(second)"
        }
        return "\(hour):\(minute):\(second)"
    }

    private func prepareMarkers() -> [RangeMarker] {
        var markerMap = [Float: RangeMarker]()

        if frame.size.width > 0 && markerTypes.count > 0 {
            let start = fmin(range.location, range.location + range.length)
            let end = fmax(range.location, range.location + range.length)
            let sortedMarkerTypes = markerTypes.sorted { $0.scale < $1.scale }
            sortedMarkerTypes.forEach { type in
                var location = start
                while location <= end {
                    let marker = RangeMarker()

                    // Only show text if value divided by 5
                    if location.truncatingRemainder(dividingBy: 5.0) == 0 {
                        marker.text = formatTimeString(time: location)
                    }
                    marker.value = location
                    marker.type = type
                    markerMap[location] = marker
                    location += type.scale
                }
            }
        }
        return markerMap.values.sorted { $0.value < $1.value }
    }
}

#endif
