//
//  Style.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/8.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

public enum NotificationViewStyle {
    case success
    case error
    case message
    case warning
    case custom(UIImage?)
}

public enum NotificationViewPosition {
    case top
    case bottom
    case navBar(UINavigationController)
}

public enum NotificationViewAccessoryType {
    case none
    case disclosureIndicator(() -> ())
    case custom(UIView)
}
