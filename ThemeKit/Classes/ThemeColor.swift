import UIKit
import SwiftUI

/// 语义化颜色：优先读 Asset Catalog（自动跟系统 Light/Dark），也可代码注册 light/dark 对。
public enum ThemeColor: String, CaseIterable {
    case background = "theme_background"
    case surface = "theme_surface"
    case primary = "theme_primary"
    case secondary = "theme_secondary"
    case label = "theme_label"
    case separator = "theme_separator"
    case danger = "theme_danger"
    case success = "theme_success"

    /// UIKit：随 `traitCollection` 自动切换
    public var uiColor: UIColor {
        if let registered = ThemeColorRegistry.uiColor(for: rawValue) {
            return registered
        }
        if let asset = UIColor(named: rawValue, in: ThemeBundle.assets, compatibleWith: nil) {
            return asset
        }
        return fallbackUIColor
    }

    /// SwiftUI
    public var color: Color {
        Color(uiColor: uiColor)
    }

    private var fallbackUIColor: UIColor {
        switch self {
        case .background:
            return UIColor { $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
                : UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1) }
        case .surface:
            return UIColor { $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1)
                : .white }
        case .primary:
            return UIColor { $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.65, green: 0.71, blue: 0.99, alpha: 1)
                : UIColor(red: 0.31, green: 0.28, blue: 0.90, alpha: 1) }
        case .secondary:
            return UIColor { $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.62, green: 0.64, blue: 0.69, alpha: 1)
                : UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1) }
        case .label:
            return UIColor { $0.userInterfaceStyle == .dark ? .white : UIColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1) }
        case .separator:
            return UIColor { $0.userInterfaceStyle == .dark
                ? UIColor(white: 0.3, alpha: 1)
                : UIColor(white: 0.78, alpha: 1) }
        case .danger:
            return UIColor { $0.userInterfaceStyle == .dark
                ? UIColor(red: 1, green: 0.45, blue: 0.45, alpha: 1)
                : UIColor(red: 0.86, green: 0.22, blue: 0.22, alpha: 1) }
        case .success:
            return UIColor { $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.35, green: 0.85, blue: 0.52, alpha: 1)
                : UIColor(red: 0.18, green: 0.65, blue: 0.35, alpha: 1) }
        }
    }
}

/// 业务侧动态注册自定义语义色（light / dark）
public enum ThemeColorRegistry {
    private static var storage: [String: UIColor] = [:]
    private static let lock = NSLock()

    public static func register(name: String, light: UIColor, dark: UIColor) {
        let dynamic = UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        }
        lock.lock()
        storage[name] = dynamic
        lock.unlock()
    }

    public static func uiColor(for name: String) -> UIColor? {
        lock.lock()
        defer { lock.unlock() }
        return storage[name]
    }

    public static func color(named name: String) -> Color {
        Color(uiColor: uiColor(for: name) ?? .label)
    }
}
