//
//  Notification.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/10.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

public extension NotificationView {
    static func showNotification(at position: NotificationViewPosition = .top,
                                 style: NotificationViewStyle,
                                 title: String?,
                                 subtitle: String?,
                                 accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: position,
                                                style: style,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    static func showSuccess(at position: NotificationViewPosition = .top,
                            title: String?,
                            subtitle: String?,
                            accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: position,
                                                style: .success,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    static func showError(at position: NotificationViewPosition = .top,
                          title: String?,
                          subtitle: String?,
                          accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: position,
                                                style: .error,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    static func showMessage(at position: NotificationViewPosition = .top,
                            title: String?,
                            subtitle: String?,
                            accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: position,
                                                style: .message,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    static func showWarning(at position: NotificationViewPosition = .top,
                            title: String?,
                            subtitle: String?,
                            accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: position,
                                                style: .warning,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }
}

public extension UINavigationController {
    func showNotification(style: NotificationViewStyle,
                          title: String?,
                          subtitle: String?,
                          accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: .navBar(self),
                                                style: style,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    func showSuccess(title: String?,
                     subtitle: String?,
                     accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: .navBar(self),
                                                style: .success,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    func showError(title: String?,
                   subtitle: String?,
                   accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: .navBar(self),
                                                style: .error,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    func showMessage(title: String?,
                     subtitle: String?,
                     accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: .navBar(self),
                                                style: .message,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }

    func showWarning(title: String?,
                     subtitle: String?,
                     accessoryType: NotificationViewAccessoryType = .none) {
        let notificationView = NotificationView(position: .navBar(self),
                                                style: .warning,
                                                title: title,
                                                subtitle: subtitle,
                                                accessoryType: accessoryType)
        notificationView.show()
    }
}
