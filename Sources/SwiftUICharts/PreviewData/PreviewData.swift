import Foundation

class PreviewData {
    static func getPieSliceData() -> [PieSliceData] {
        [
            PieSliceData(label: "toto", color: CGColor(red: 1, green: 0, blue: 0, alpha: 1), value: 86),
            PieSliceData(label: "tr", color: CGColor(red: 0, green: 1, blue: 0, alpha: 1), value: 56),
            PieSliceData(label: "twe", color: CGColor(red: 0, green: 0, blue: 1, alpha: 1), value: 78),
            PieSliceData(label: "toe", color: CGColor(red: 1, green: 1, blue: 0, alpha: 1), value: 53),
            PieSliceData(label: "totro", color: CGColor(red: 1, green: 0, blue: 1, alpha: 1), value: 65),
            PieSliceData(label: "tototrt", color: CGColor(red: 1, green: 1, blue: 1, alpha: 1), value: 54),
        ]
    }
}
