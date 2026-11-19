import SwiftUI
import UIKit

/// 统一入口：`Theme.color.primary` / `Theme.image.network`
public enum Theme {
    public enum color {
        public static let background = ThemeColor.background.color
        public static let surface = ThemeColor.surface.color
        public static let primary = ThemeColor.primary.color
        public static let secondary = ThemeColor.secondary.color
        public static let label = ThemeColor.label.color
        public static let separator = ThemeColor.separator.color
        public static let danger = ThemeColor.danger.color
        public static let success = ThemeColor.success.color

        public static func ui(_ token: ThemeColor) -> UIColor { token.uiColor }
        public static func swiftUI(_ token: ThemeColor) -> Color { token.color }
        public static func custom(_ name: String) -> Color { ThemeColorRegistry.color(named: name) }
    }

    public enum image {
        public static let empty = ThemeImage.empty
        public static let network = ThemeImage.network

        public static func view(_ token: ThemeImage) -> ThemeImageView {
            ThemeImageView(token)
        }

        public static func custom(_ name: String) -> ThemeImageView {
            ThemeImageView(customName: name)
        }
    }
}

public extension Color {
    static var theme: Theme.color.Type { Theme.color.self }
}

public extension Image {
    /// `Image.theme(.network)` → SwiftUI Image（静态抓取当前 trait）
    static func theme(_ token: ThemeImage) -> Image {
        token.image
    }
}
