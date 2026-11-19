import UIKit
import SwiftUI

/// 语义化图片：优先 Asset Catalog（Any + Dark），也可注册 light/dark 两套图或 SF Symbol。
public enum ThemeImage: String, CaseIterable {
    case empty = "theme_empty"
    case network = "theme_network"

    /// UIKit：随当前 trait 自动取 Light/Dark 资源
    public func uiImage(compatibleWith traits: UITraitCollection? = nil) -> UIImage? {
        if let registered = ThemeImageRegistry.uiImage(named: rawValue, compatibleWith: traits) {
            return registered
        }
        return UIImage(named: rawValue, in: ThemeBundle.assets, compatibleWith: traits)
    }

    /// SwiftUI
    public var image: Image {
        if let ui = uiImage() {
            return Image(uiImage: ui)
        }
        return Image(systemName: "photo")
    }
}

public enum ThemeImageRegistry {
    private struct Pair {
        let light: UIImage
        let dark: UIImage
    }

    private static var pairs: [String: Pair] = [:]
    private static var symbols: [String: String] = [:]
    private static let lock = NSLock()

    /// 注册两张图（Light / Dark），运行时按界面样式选取
    public static func register(name: String, light: UIImage, dark: UIImage) {
        lock.lock()
        pairs[name] = Pair(light: light, dark: dark)
        lock.unlock()
    }

    /// 注册 SF Symbol 名（深浅色可用同一 symbol，颜色交给 tint）
    public static func registerSymbol(name: String, systemName: String) {
        lock.lock()
        symbols[name] = systemName
        lock.unlock()
    }

    public static func uiImage(named name: String, compatibleWith traits: UITraitCollection? = nil) -> UIImage? {
        lock.lock()
        let pair = pairs[name]
        let symbol = symbols[name]
        lock.unlock()

        if let pair {
            let style = (traits ?? UITraitCollection.current).userInterfaceStyle
            return style == .dark ? pair.dark : pair.light
        }
        if let symbol {
            return UIImage(systemName: symbol)
        }
        return nil
    }
}

/// SwiftUI 视图：随 `@Environment(\.colorScheme)` 切换图片
public struct ThemeImageView: View {
    private let name: String
    private let bundleAsset: ThemeImage?

    @Environment(\.colorScheme) private var colorScheme

    public init(_ image: ThemeImage) {
        self.name = image.rawValue
        self.bundleAsset = image
    }

    public init(customName: String) {
        self.name = customName
        self.bundleAsset = nil
    }

    public var body: some View {
        Group {
            if let ui = resolveUIImage() {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(ThemeColor.secondary.color)
            }
        }
        // colorScheme 变化时重算，确保注册的 light/dark 对能刷新
        .id(colorScheme)
    }

    private func resolveUIImage() -> UIImage? {
        let traits = UITraitCollection(userInterfaceStyle: colorScheme == .dark ? .dark : .light)
        if let bundleAsset {
            return bundleAsset.uiImage(compatibleWith: traits)
        }
        return ThemeImageRegistry.uiImage(named: name, compatibleWith: traits)
            ?? UIImage(named: name, in: ThemeBundle.assets, compatibleWith: traits)
    }
}
