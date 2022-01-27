import Foundation
import CoreGraphics

public struct PieSliceData {
    let label: String;
    let color: CGColor;
    let value: Double;

    public init(label: String, color: CGColor, value: Double) {
        self.label = label
        self.color = color
        self.value = value
    }
}
