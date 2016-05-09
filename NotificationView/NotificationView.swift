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
    public var duration: NSTimeInterval = 3

    public private(set) var isAnimating = false
    public private(set) var position: NotificationViewPosition!
    public private(set) var style: NotificationViewStyle!
    public private(set) var title: String?
    public private(set) var subtitle: String?
    /// The type of standard accessory view the notification should use.
    public private(set) var accessoryType: NotificationViewAccessoryType = .None
    /// A view that is used, typically as a control, on the right side of the notification.
    ///
    /// If the value of this property is not nil, the NotificationView uses the given view for the accessory view in the right side of notification; it ignores the value of the accessoryType property.
    public private(set) var accessoryView: UIView?

    private var dismissTimer: NSTimer?
    private var verticalConstraints = [NSLayoutConstraint]()
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
    private lazy var tapAction = #selector(NotificationView.notificationViewTapped)

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

public extension NotificationView {
    // MARK: - Initialization
    public convenience init(position: NotificationViewPosition = .Top,
                            style: NotificationViewStyle,
                            title: String?,
                            subtitle: String? = nil,
                            accessoryType: NotificationViewAccessoryType = .None,
                            accessoryView: UIView? = nil) {
        self.init(frame: CGRect.zero)
        self.position = position
        self.style = style
        self.title = title
        self.subtitle = subtitle
        self.accessoryType = accessoryType
        self.accessoryView = accessoryView

        configureNotification()
        configureGestureRecognizer()
    }

    // MARK: - Helper
    private func configureNotification() {
        translatesAutoresizingMaskIntoConstraints = false

        switch style! {
        case .Simple:
            titleLabel.font = Notification.simpleTitleFont
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.textAlignment = .Center
            titleLabel.text = title

            addSubview(titleLabel)
            addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[titleLabel]|", options: [], metrics: nil, views: ["titleLabel": titleLabel]))
        default:
            backgroundColor = UIColor(white: 0, alpha: 0.85)
            layer.cornerRadius = Notification.cornerRadius
            clipsToBounds = false
            layer.shadowColor = Notification.shadowColor
            layer.shadowOffset = Notification.shadowOffset
            layer.shadowOpacity = Notification.shadowOpacity
            layer.shadowRadius = Notification.shadowRadius

            let iconName: String = {
                switch style! {
                case .Success: return "successIcon"
                case .Error: return "errorIcon"
                case .Warning: return "warningIcon"
                default: return "messageIcon"
                }
            }()
            let icon = UIImage(named: iconName, inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
            iconImageView.image = icon

            addSubview(iconImageView)
            addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: NotificationLayout.iconSize.width))
            addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: NotificationLayout.iconSize.height))
            addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))

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
        }

        var rightAccessoryView: UIView?
        if let accessoryView = accessoryView {
            rightAccessoryView = accessoryView
            accessoryView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(accessoryView)
        } else {
            switch accessoryType {
            case .None:
                break
            case .DisclosureIndicator(let action):
                tapAction = #selector(notificationViewDisclosureIndicatorTapped)
                let disclosureIndicator = UIImage(named: "disclosureIndicator", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
                let imageView = UIImageView(image: disclosureIndicator)
                rightAccessoryView = imageView
                imageView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(imageView)
            case .Button(let button):
                rightAccessoryView = button
                button.translatesAutoresizingMaskIntoConstraints = false
                addSubview(button)
            }
        }

        if let rightAccessoryView = rightAccessoryView {
            addConstraint(NSLayoutConstraint(item: rightAccessoryView, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: rightAccessoryView.frame.width))
            addConstraint(NSLayoutConstraint(item: rightAccessoryView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: rightAccessoryView.frame.height))
            addConstraint(NSLayoutConstraint(item: rightAccessoryView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))

            let visualFormat = "H:|-\(NotificationLayout.iconLeading)-[iconImageView]-\(NotificationLayout.labelHorizontalPadding)-[titleLabel]-\(NotificationLayout.labelHorizontalPadding)-[rightAccessoryView]-\(NotificationLayout.accessoryViewTrailing)-|"
            let views = ["iconImageView": iconImageView, "titleLabel": titleLabel, "rightAccessoryView": rightAccessoryView]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: [], metrics: nil, views: views))
        } else {
            let visualFormat = "H:|-\(NotificationLayout.iconLeading)-[iconImageView]-\(NotificationLayout.labelHorizontalPadding)-[titleLabel]-\(NotificationLayout.labelHorizontalPadding)-|"
            let views = ["iconImageView": iconImageView, "titleLabel": titleLabel]
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: [], metrics: nil, views: views))
        }

        layoutIfNeeded()
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
}

public extension NotificationView {
    // MARK: - Life cycle
    public func show(animationDuration: NSTimeInterval = 0.5, completion: (() -> Void)? = nil) {
        func show() {
            switch position! {
            case .NavBar(let navigationController):
                let isNavBarHidden = navigationController.navigationBar.hidden || navigationController.navigationBarHidden
                let isNavBarOpaque = !navigationController.navigationBar.translucent && navigationController.navigationBar.alpha == 1
            default:
                guard let notificationWindow = UIWindow.notificationWindow else {
                    print("Show notification error: can not find a window to show notification")
                    return
                }

                notificationWindow.addSubview(self)
                guard let superview = superview else {
                    return
                }

                let height = style! == .Simple ? NotificationLayout.simpleNotificationHeight : NotificationLayout.notificationHeight
                superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: height))
                superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: NotificationLayout.notificationMaxWidth))
                superview.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1, constant: 0))
                let leadingSpace = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: superview, attribute: .Leading, multiplier: 1, constant: NotificationLayout.notificationSpacing)
                let trailingSpace = NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: superview, attribute: .Trailing, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                leadingSpace.priority = UILayoutPriorityDefaultHigh
                trailingSpace.priority = UILayoutPriorityDefaultHigh
                superview.addConstraints([leadingSpace, trailingSpace])

                let preparatoryVerticalConstraints: [NSLayoutConstraint] = {
                    switch position! {
                    case .Top:
                        let topSpace = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                        return [topSpace]
                    case .Bottom:
                        let bottomSpace = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: NotificationLayout.notificationSpacing)
                        return [bottomSpace]
                    default:
                        return []
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
                default:
                    break
                }
                superview.addConstraints(verticalConstraints)

                isAnimating = true
                NotificationView.sharedNotification = self
                UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [.AllowAnimatedContent, .BeginFromCurrentState], animations: {
                    self.layoutIfNeeded()
                    }, completion: { (finished) in
                        dispatch_async(dispatch_get_main_queue(), {
                            self.isAnimating = false
                            NotificationView.delegate?.didShowNotificationView(self)

                            if let completion = completion {
                                completion()
                            }
                        })
                })
            }
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

        NotificationView.delegate?.willDismissNotificationView(self)
        superview?.removeConstraints(verticalConstraints)
        verticalConstraints.removeAll()
        let destinationVerticalConstraints: [NSLayoutConstraint] = {
            switch position! {
            case .Top:
                let topSpace = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
                return [topSpace]
            case .Bottom:
                let bottomSpace = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: NotificationLayout.notificationSpacing)
                return [bottomSpace]
            default:
                return []
            }
        }()
        superview?.addConstraints(destinationVerticalConstraints)

        isAnimating = true
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [.AllowAnimatedContent, .BeginFromCurrentState], animations: {
            self.layoutIfNeeded()
            }) { (finished) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.isAnimating = false
                    self.removeFromSuperview()
                    NotificationView.sharedNotification = nil
                    NotificationView.delegate?.didDismissNotificationView(self)

                    if let completion = completion {
                        completion()
                    }
                })
        }
    }
}
