//
//  NotificationView.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/8.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

public class NotificationView: UIView {
    // MARK: - Properties
    public weak var delegate: NotificationViewDelegate?
    public var titleFont = UIFont.systemFontOfSize(16) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    public var titleTextColor = UIColor.whiteColor() {
        didSet {
            titleLabel.textColor = titleTextColor
        }
    }
    public var subtitleFont = UIFont.systemFontOfSize(12) {
        didSet {
            subtitleLabel.font = subtitleFont
        }
    }
    public var subtitleTextColor = UIColor.whiteColor() {
        didSet {
            subtitleLabel.textColor = subtitleTextColor
        }
    }
    public var accessoryType: NotificationViewAccessoryType = .None
    public var accessoryView: UIView?

    public private(set) var style: NotificationViewStyle!
    public private(set) var title: String?
    public private(set) var subtitle: String?

    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    private lazy var titleLabel: UILabel = { [unowned self] in
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = self.titleFont
        titleLabel.textColor = self.titleTextColor
        return titleLabel
    }()
    private lazy var subtitleLabel: UILabel = { [unowned self] in
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.backgroundColor = UIColor.clearColor()
        subtitleLabel.font = self.subtitleFont
        subtitleLabel.textColor = self.subtitleTextColor
        return subtitleLabel
    }()

    // MARK: - Initialization
    
}
