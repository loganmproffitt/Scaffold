import SwiftUI

enum AppStyling {
    enum Colors {
        static let presetHexColors: [String] = [
            "#FF9F1C", "#2EC4B6", "#E71D36", "#011627", "#FFBF69"
        ]
        
        // Later: named presets or Color versions if needed
        static let presetColors: [Color] = presetHexColors.map { Color(hex: $0) }
    }
}
