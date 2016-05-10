//
//  Delegate.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/9.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

public protocol NotificationViewDelegate: class {
    func shouldShowNotificationView(notificationView: NotificationView) -> Bool
    func willShowNotificationView(notificationView: NotificationView)
    func didShowNotificationView(notificationView: NotificationView)
    func shouldDismissNotificationView(notificationView: NotificationView) -> Bool
    func willDismissNotificationView(notificationView: NotificationView)
    func didDismissNotificationView(notificationView: NotificationView)
}

public extension NotificationViewDelegate {
    func shouldShowNotificationView(notificationView: NotificationView) -> Bool {
        return true
    }

    func willShowNotificationView(notificationView: NotificationView) {

    }

    func didShowNotificationView(notificationView: NotificationView) {

    }

    func shouldDismissNotificationView(notificationView: NotificationView) -> Bool {
        return true
    }

    func willDismissNotificationView(notificationView: NotificationView) {

    }

    func didDismissNotificationView(notificationView: NotificationView) {

    }
}
