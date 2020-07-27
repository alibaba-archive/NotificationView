#
#  Created by teambition-ios on 2020/7/27.
#  Copyright © 2020 teambition. All rights reserved.
#     

Pod::Spec.new do |s|
  s.name             = 'TBNotificationView'
  s.version          = '1.0.0'
  s.summary          = 'Easy to use and customizable messages/notifications for iOS applications.'
  s.description      = <<-DESC
  Easy to use and customizable messages/notifications for iOS applications..
                       DESC

  s.homepage         = 'https://github.com/teambition/NotificationView'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'teambition mobile' => 'teambition-mobile@alibaba-inc.com' }
  s.source           = { :git => 'https://github.com/teambition/NotificationView.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'NotificationView/*.swift'

end
