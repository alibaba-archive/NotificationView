//
//  Constants.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/9.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

internal let UILayoutPriorityNotificationPadding: Float = 999

internal struct Notification {
    static let cornerRadius: CGFloat = 4
    static let shadowColor = UIColor.blackColor().CGColor
    static let shadowOffset = CGSize(width: 0, height: 4)
    static let shadowOpacity: Float = 0.5
    static let shadowRadius: CGFloat = 6

    static let titleFont = UIFont.systemFontOfSize(16)
    static let subtitleFont = UIFont.systemFontOfSize(12)
}

internal struct NotificationLayout {
    static let notificationSpacing: CGFloat = 10
    static let notificationHeight: CGFloat = 60
    static let notificationMaxWidth: CGFloat = 500

    static let iconSize = CGSize(width: 36, height: 36)
    static let iconLeading: CGFloat = 15

    static let labelHorizontalPadding: CGFloat = 10
    static let labelVerticalPadding: CGFloat = 10

    static let accessoryViewTrailing: CGFloat = 15
}
