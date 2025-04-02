import SwiftUI

enum ColorUtils {
    
    static func randomHexColor() -> String {
        AppStyling.Colors.presetHexColors.randomElement() ?? "#999999"
    }

    static func randomColor() -> Color {
        Color(hex: randomHexColor())
    }

    static func contrastColor(for background: Color) -> Color {
        let uiColor = UIColor(background)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let brightness = (red * 299 + green * 587 + blue * 114) * 255 / 1000

        return brightness > 186 ? .black : .white
    }

}
