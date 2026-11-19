Pod::Spec.new do |s|
  s.name             = 'ThemeKit'
  s.version          = '0.1.0'
  s.summary          = 'Dark-mode adaptive colors and images for UIKit & SwiftUI.'
  s.description      = <<-DESC
    ThemeKit provides semantic colors and images that automatically adapt to
    Light / Dark appearance. Use asset-catalog appearances or explicit light/dark pairs.
  DESC
  s.homepage         = 'https://github.com/frechai/ThemeKit'
  s.license          = { :type => 'MIT' }
  s.author           = { 'frechai' => 'dev@example.com' }
  s.source           = { :git => 'https://github.com/frechai/ThemeKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '17.0'
  s.swift_version = '5.9'

  s.source_files = 'ThemeKit/Classes/**/*.swift'
  s.resource_bundles = {
    'ThemeKit' => ['ThemeKit/Assets/ThemeKit.xcassets']
  }

  s.frameworks = 'UIKit', 'SwiftUI'
end
