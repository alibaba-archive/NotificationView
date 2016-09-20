//
//  Protocols.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/9.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

public protocol NotificationViewDelegate: class {
    func shouldShowNotificationView(_ notificationView: NotificationView) -> Bool
    func willShowNotificationView(_ notificationView: NotificationView)
    func didShowNotificationView(_ notificationView: NotificationView)
    func shouldDismissNotificationView(_ notificationView: NotificationView) -> Bool
    func willDismissNotificationView(_ notificationView: NotificationView)
    func didDismissNotificationView(_ notificationView: NotificationView)
}

public extension NotificationViewDelegate {
    func shouldShowNotificationView(_ notificationView: NotificationView) -> Bool {
        return true
    }

    func willShowNotificationView(_ notificationView: NotificationView) {

    }

    func didShowNotificationView(_ notificationView: NotificationView) {

    }

    func shouldDismissNotificationView(_ notificationView: NotificationView) -> Bool {
        return true
    }

    func willDismissNotificationView(_ notificationView: NotificationView) {

    }

    func didDismissNotificationView(_ notificationView: NotificationView) {

    }
}
