//
//  Style.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/8.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

public enum NotificationViewStyle {
    case Simple
    case Success
    case Error
    case Message
    case Warning
}

public enum NotificationViewPosition {
    case Top
    case Bottom
    case NavBar(UINavigationController)
}

public enum NotificationViewAccessoryType {
    case None
    case DisclosureIndicator(() -> Void)
    case Button(UIButton)
}
