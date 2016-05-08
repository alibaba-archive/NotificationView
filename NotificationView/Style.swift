//
//  Style.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/8.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public enum NotificationViewStyle {
    case Simple
    case Success
    case Error
    case Info
    case Warning
}

public enum NotificationViewPosition {
    case Top
    case Bottom
    case NavBarOverlay
}

public enum NotificationViewAccessoryType {
    case None
    case DisclosureIndicator
    case Button(String)
}
