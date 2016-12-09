Pod::Spec.new do |s|

  s.name         = "NotificationView"
  s.version      = "0.0.1"
  s.summary      = "Easy to use and customizable messages/notifications for iOS applications."

  s.homepage     = "https://github.com/teambition/NotificationView"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = "Xin Hong"

  s.source       = { :git => "https://github.com/teambition/NotificationView.git", :tag => s.version.to_s }
  s.source_files = "NotificationView/*.swift"

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.frameworks   = "Foundation", "UIKit"

end