# ThemeKit

暗黑模式自适应 **颜色 + 图片** 组件（CocoaPods）。

仓库：https://github.com/frechai/ThemeKit

## 接入

```ruby
# 本地联调（path）
pod 'ThemeKit', :path => 'LocalPods/ThemeKit'

# 远端版本
pod 'ThemeKit', :git => 'https://github.com/frechai/ThemeKit.git', :tag => '0.1.0'
```

```shell
pod install
```

```swift
import ThemeKit
```

## 颜色

```swift
// SwiftUI
Text("标题").foregroundStyle(Theme.color.label)
RoundedRectangle(cornerRadius: 12).fill(Theme.color.surface)

// UIKit
view.backgroundColor = Theme.color.ui(.background)

// 业务自定义 light/dark
ThemeColorRegistry.register(
    name: "brand_accent",
    light: UIColor.systemOrange,
    dark: UIColor.orange
)
Color.theme.custom("brand_accent")
```

## 图片

```swift
// Asset Catalog（已带 Any + Dark）
Theme.image.view(.network)
    .frame(width: 48, height: 48)

// 注册两套图
ThemeImageRegistry.register(
    name: "door_icon",
    light: UIImage(named: "door_light")!,
    dark: UIImage(named: "door_dark")!
)
Theme.image.custom("door_icon")

// SF Symbol
ThemeImageRegistry.registerSymbol(name: "scan", systemName: "dot.radiowaves.left.and.right")
```

## 扩展资源

在 `ThemeKit/Assets/ThemeKit.xcassets` 增加 Color Set / Image Set，勾选 **Appearances → Any, Dark**，即可自动适配。
