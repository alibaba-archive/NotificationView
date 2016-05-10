//
//  Notification.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/10.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

public extension NotificationView {
    public static func showNotification(position: NotificationViewPosition = .Top,
                                        style: NotificationViewStyle,
                                        title: String?,
                                        subtitle: String?,
                                        accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: position,
                                                style: style,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    public static func showSuccess(position: NotificationViewPosition = .Top,
                                   title: String?,
                                   subtitle: String?,
                                   accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: position,
                                                style: .Success,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    public static func showError(position: NotificationViewPosition = .Top,
                                 title: String?,
                                 subtitle: String?,
                                 accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: position,
                                                style: .Error,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    public static func showMessage(position: NotificationViewPosition = .Top,
                                   title: String?,
                                   subtitle: String?,
                                   accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: position,
                                                style: .Message,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    public static func showWarning(position: NotificationViewPosition = .Top,
                                   title: String?,
                                   subtitle: String?,
                                   accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: position,
                                                style: .Warning,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }
}

public extension UINavigationController {
    public func showNotification(style: NotificationViewStyle,
                                 title: String?,
                                 subtitle: String?,
                                 accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: .NavBar(self),
                                                style: style,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    public func showSuccess(title title: String?,
                                  subtitle: String?,
                                  accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: .NavBar(self),
                                                style: .Success,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    public func showError(title title: String?,
                                subtitle: String?,
                                accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: .NavBar(self),
                                                style: .Error,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    public func showMessage(title title: String?,
                                  subtitle: String?,
                                  accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: .NavBar(self),
                                                style: .Message,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    public func showWarning(title title: String?,
                                  subtitle: String?,
                                  accessoryType: NotificationViewAccessoryType = .None) {
        let notificationView = NotificationView(position: .NavBar(self),
                                                style: .Warning,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }
}
