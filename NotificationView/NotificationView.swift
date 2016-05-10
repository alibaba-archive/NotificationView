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
    public static var sharedNotification: NotificationView?

    public weak static var delegate: NotificationViewDelegate?
    public var titleFont = Notification.titleFont {
        didSet {
            titleLabel.font = titleFont
        }
    }
    public var titleTextColor = UIColor.whiteColor() {
        didSet {
            titleLabel.textColor = titleTextColor
        }
    }
    public var subtitleFont = Notification.subtitleFont {
        didSet {
            subtitleLabel.font = subtitleFont
        }
    }
    public var subtitleTextColor = UIColor.whiteColor() {
        didSet {
            subtitleLabel.textColor = subtitleTextColor
        }
    }
    public var duration: NSTimeInterval = 2.5

    public private(set) var isAnimating = false
    public private(set) var position: NotificationViewPosition!
    public private(set) var style: NotificationViewStyle!
    public private(set) var title: String?
    public private(set) var subtitle: String?
    public private(set) var accessoryType: NotificationViewAccessoryType = .None

    private var dismissTimer: NSTimer?
    private var verticalConstraints = [NSLayoutConstraint]()
    private var tapAction = #selector(NotificationView.notificationViewTapped)
    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    private lazy var titleLabel: UILabel = { [unowned self] in
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textAlignment = .Left
        titleLabel.font = self.titleFont
        titleLabel.textColor = self.titleTextColor
        return titleLabel
    }()
    private lazy var subtitleLabel: UILabel = { [unowned self] in
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.backgroundColor = UIColor.clearColor()
        subtitleLabel.textAlignment = .Left
        subtitleLabel.font = self.subtitleFont
        subtitleLabel.textColor = self.subtitleTextColor
        return subtitleLabel
    }()

    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public convenience init(position: NotificationViewPosition,
                            style: NotificationViewStyle,
                            title: String?,
                            subtitle: String?,
                            accessoryType: NotificationViewAccessoryType = .None) {
        self.init(frame: CGRect.zero)
        self.position = position
        self.style = style
        self.title = title
        self.subtitle = subtitle
        self.accessoryType = accessoryType
        
        configureNotification()
        configureGestureRecognizer()
    }
}

extension NotificationView {
    // MARK: - Helper
    private func configureNotification() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(white: 0, alpha: 0.85)
        layer.cornerRadius = Notification.cornerRadius
        clipsToBounds = false
        layer.shadowColor = Notification.shadowColor
        layer.shadowOffset = Notification.shadowOffset
        layer.shadowOpacity = Notification.shadowOpacity
        layer.shadowRadius = Notification.shadowRadius

        let icon: UIImage? = {
            switch style! {
            case .Custom(let icon):
                return icon
            default:
                var iconName: String
                switch style! {
                case .Success: iconName = "successIcon"
                case .Error: iconName = "errorIcon"
                case .Warning: iconName = "warningIcon"
                default: iconName = "messageIcon"
                }
                return UIImage(named: iconName, inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
            }
        }()

        if let icon = icon {
            iconImageView.image = icon

            addSubview(iconImageView)
            addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: NotificationLayout.iconSize.width))
            addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: NotificationLayout.iconSize.height))
            addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        }

        titleLabel.text = title
        addSubview(titleLabel)
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            addSubview(subtitleLabel)

            addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: NotificationLayout.labelVerticalPadding))
            addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: subtitleLabel, attribute: .Bottom, multiplier: 1, constant: NotificationLayout.labelVerticalPadding))
            addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .Leading, relatedBy: .Equal, toItem: titleLabel, attribute: .Leading, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: titleLabel, attribute: .Trailing, multiplier: 1, constant: 0))
        } else {
            addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        }

        var accessoryView: UIView?
        switch accessoryType {
        case .None:
            break
        case .DisclosureIndicator(_):
            tapAction = #selector(notificationViewDisclosureIndicatorTapped)
            let disclosureIndicator = UIImage(named: "disclosureIndicator", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
            let imageView = UIImageView(image: disclosureIndicator)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            accessoryView = imageView
        case .Custom(let view):
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            accessoryView = view
        }

        if let accessoryView = accessoryView {
            addConstraint(NSLayoutConstraint(item: accessoryView, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: accessoryView.frame.width))
            addConstraint(NSLayoutConstraint(item: accessoryView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: accessoryView.frame.height))
            addConstraint(NSLayoutConstraint(item: accessoryView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        }

        var views: [String: AnyObject] = ["titleLabel": titleLabel]
        var horizontalFormat = String()
        let labelLeftPadding = icon != nil ? NotificationLayout.labelHorizontalPadding : NotificationLayout.iconLeading
        let labelRightPadding = accessoryView != nil ? NotificationLayout.labelHorizontalPadding : NotificationLayout.accessoryViewTrailing

        if let _ = icon {
            horizontalFormat += "\(NotificationLayout.iconLeading)-[iconImageView]-"
            views.updateValue(iconImageView, forKey: "iconImageView")
        }
        horizontalFormat += "\(labelLeftPadding)-[titleLabel]-\(labelRightPadding)"
        if let rightAccessoryView = accessoryView {
            horizontalFormat += "-[rightAccessoryView]-\(NotificationLayout.accessoryViewTrailing)"
            views.updateValue(rightAccessoryView, forKey: "rightAccessoryView")
        }
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(horizontalFormat)-|", options: [], metrics: nil, views: views))
    }

    private func configureGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: tapAction)
        let swipeGesture: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(notificationViewSwiped))
            switch position! {
            case .Top, .NavBar: swipeGesture.direction = .Up
            case .Bottom: swipeGesture.direction = .Down
            }
            return swipeGesture
        }()
        userInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(swipeGesture)
    }

    func notificationViewTapped() {
        dismiss()
    }

    func notificationViewSwiped() {
        dismiss()
    }

    func notificationViewDisclosureIndicatorTapped() {
        switch accessoryType {
        case .DisclosureIndicator(let action):
            action()
        default:
            break
        }
    }

    func dismissTimerInvocation(timer: NSTimer) {
        dismiss()
    }
}

public extension NotificationView {
    // MARK: - Life cycle
    public func show(animationDuration: NSTimeInterval = 0.5, completion: (() -> Void)? = nil) {
        func show() {
            switch position! {
            case .Top, .Bottom:
                alpha = 1
                UIWindow.notificationWindow?.addSubview(self)
            case .NavBar(let navigationController):
                alpha = 0
                navigationController.view.insertSubview(self, belowSubview: navigationController.navigationBar)
            }

            guard let superview = superview else {
                print("Show notification error: can not find a window to show notification")
                return
            }

            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: NotificationLayout.notificationHeight))
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: NotificationLayout.notificationMaxWidth))
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1, constant: 0))
            let leadingSpace = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: superview, attribute: .Leading, multiplier: 1, constant: NotificationLayout.notificationSpacing)
            let trailingSpace = NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: superview, attribute: .Trailing, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
            leadingSpace.priority = UILayoutPriorityNotificationPadding
            trailingSpace.priority = UILayoutPriorityNotificationPadding
            superview.addConstraints([leadingSpace, trailingSpace])

            let preparatoryVerticalConstraints: [NSLayoutConstraint] = {
                switch position! {
                case .Top:
                    let topSpace = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                    return [topSpace]
                case .Bottom:
                    let bottomSpace = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: NotificationLayout.notificationSpacing)
                    return [bottomSpace]
                case .NavBar(let navigationController):
                    let isNavBarHidden = navigationController.navigationBar.hidden || navigationController.navigationBarHidden
                    if isNavBarHidden {
                        let topSpace = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: navigationController.view, attribute: .Top, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                        return [topSpace]
                    } else {
                        let topSpace = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: navigationController.navigationBar, attribute: .Bottom, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                        return [topSpace]
                    }
                }
            }()
            superview.addConstraints(preparatoryVerticalConstraints)
            layoutIfNeeded()

            NotificationView.delegate?.willShowNotificationView(self)
            superview.removeConstraints(preparatoryVerticalConstraints)
            verticalConstraints.removeAll()
            switch position! {
            case .Top:
                let topSpace = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: NotificationLayout.notificationSpacing)
                verticalConstraints = [topSpace]
            case .Bottom:
                let bottomSpace = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                verticalConstraints = [bottomSpace]
            case .NavBar(let navigationController):
                let isNavBarHidden = navigationController.navigationBar.hidden || navigationController.navigationBarHidden
                if isNavBarHidden {
                    let topSpace = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: navigationController.view, attribute: .Top, multiplier: 1, constant: NotificationLayout.notificationSpacing)
                    verticalConstraints = [topSpace]
                } else {
                    let topSpace = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: navigationController.navigationBar, attribute: .Bottom, multiplier: 1, constant: NotificationLayout.notificationSpacing)
                    verticalConstraints = [topSpace]
                }
            }
            superview.addConstraints(verticalConstraints)

            isAnimating = true
            NotificationView.sharedNotification = self
            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [.AllowAnimatedContent, .BeginFromCurrentState], animations: {
                switch self.position! {
                case .NavBar(_): self.alpha = 1
                default: break
                }
                self.layoutIfNeeded()
                }, completion: { (finished) in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.isAnimating = false
                        self.dismissTimer = NSTimer.scheduledTimerWithTimeInterval(self.duration, target: self, selector: #selector(self.dismissTimerInvocation(_:)), userInfo: nil, repeats: false)
                        NotificationView.delegate?.didShowNotificationView(self)

                        if let completion = completion {
                            completion()
                        }
                    })
            })
        }

        let shouldShowNotification = NotificationView.delegate?.shouldShowNotificationView(self) ?? true
        guard shouldShowNotification else {
            return
        }

        if let sharedNotification = NotificationView.sharedNotification {
            if sharedNotification.isAnimating {
                sharedNotification.isAnimating = false
                sharedNotification.removeFromSuperview()
                NotificationView.sharedNotification = nil
                self.dismissTimer?.invalidate()
                self.dismissTimer = nil
                NotificationView.delegate?.didDismissNotificationView(sharedNotification)
                show()
            } else {
                sharedNotification.dismiss(0.12, completion: {
                    show()
                })
            }
        } else {
            show()
        }
    }

    public func dismiss(animationDuration: NSTimeInterval = 0.4, completion: (() -> Void)? = nil) {
        let shouldDismissNotification = NotificationView.delegate?.shouldDismissNotificationView(self) ?? true
        guard shouldDismissNotification else {
            return
        }

        guard let superview = superview else {
            return
        }

        NotificationView.delegate?.willDismissNotificationView(self)
        superview.removeConstraints(verticalConstraints)
        verticalConstraints.removeAll()
        let destinationVerticalConstraints: [NSLayoutConstraint] = {
            switch position! {
            case .Top:
                let topSpace = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                return [topSpace]
            case .Bottom:
                let bottomSpace = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: NotificationLayout.notificationSpacing)
                return [bottomSpace]
            case .NavBar(let navigationController):
                let isNavBarHidden = navigationController.navigationBar.hidden || navigationController.navigationBarHidden
                if isNavBarHidden {
                    let topSpace = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: navigationController.view, attribute: .Top, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                    return [topSpace]
                } else {
                    let topSpace = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: navigationController.navigationBar, attribute: .Bottom, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                    return [topSpace]
                }
            }
        }()
        superview.addConstraints(destinationVerticalConstraints)

        isAnimating = true
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [.AllowAnimatedContent, .BeginFromCurrentState], animations: {
            switch self.position! {
            case .NavBar(_): self.alpha = 0
            default: break
            }
            self.layoutIfNeeded()
            }) { (finished) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.isAnimating = false
                    self.removeFromSuperview()
                    NotificationView.sharedNotification = nil
                    self.dismissTimer?.invalidate()
                    self.dismissTimer = nil
                    NotificationView.delegate?.didDismissNotificationView(self)

                    if let completion = completion {
                        completion()
                    }
                })
        }
    }
}
