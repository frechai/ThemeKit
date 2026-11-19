import Foundation

enum ThemeBundle {
    /// CocoaPods resource_bundles → ThemeKit.bundle
    static let assets: Bundle = {
        let candidates: [Bundle] = [
            Bundle(for: ThemeBundleToken.self),
            Bundle.main
        ]

        for bundle in candidates {
            if let url = bundle.url(forResource: "ThemeKit", withExtension: "bundle"),
               let resourceBundle = Bundle(url: url) {
                return resourceBundle
            }
        }

        // SPM / 直接编进 app 时的兜底
        return Bundle(for: ThemeBundleToken.self)
    }()
}

private final class ThemeBundleToken {}
