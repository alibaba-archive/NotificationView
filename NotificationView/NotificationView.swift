//
//  NotificationView.swift
//  NotificationView
//
//  Created by Xin Hong on 16/5/8.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

open class NotificationView: UIView {
    // MARK: - Properties
    public static var sharedNotification: NotificationView?

    public weak static var delegate: NotificationViewDelegate?
    open var titleFont = Notification.titleFont {
        didSet {
            titleLabel.font = titleFont
        }
    }
    open var titleTextColor = UIColor.white {
        didSet {
            titleLabel.textColor = titleTextColor
        }
    }
    open var subtitleFont = Notification.subtitleFont {
        didSet {
            subtitleLabel.font = subtitleFont
        }
    }
    open var subtitleTextColor = UIColor.white {
        didSet {
            subtitleLabel.textColor = subtitleTextColor
        }
    }
    open var duration: TimeInterval = 2.5

    open fileprivate(set) var isAnimating = false
    open fileprivate(set) var position: NotificationViewPosition!
    open fileprivate(set) var style: NotificationViewStyle!
    open fileprivate(set) var title: String?
    open fileprivate(set) var subtitle: String?
    open fileprivate(set) var accessoryType: NotificationViewAccessoryType = .none

    fileprivate var dismissTimer: Timer?
    fileprivate var verticalPositionConstraint: NSLayoutConstraint!
    fileprivate var tapAction = #selector(NotificationView.notificationViewTapped)
    fileprivate lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    fileprivate lazy var titleLabel: UILabel = { [unowned self] in
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .left
        titleLabel.font = self.titleFont
        titleLabel.textColor = self.titleTextColor
        return titleLabel
    }()
    fileprivate lazy var subtitleLabel: UILabel = { [unowned self] in
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textAlignment = .left
        subtitleLabel.font = self.subtitleFont
        subtitleLabel.textColor = self.subtitleTextColor
        subtitleLabel.numberOfLines = 2
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
                            accessoryType: NotificationViewAccessoryType = .none) {
        self.init(frame: .zero)
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
    fileprivate func configureNotification() {
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
            case .custom(let icon):
                return icon
            default:
                var iconName: String
                switch style! {
                case .success: iconName = "successIcon"
                case .error: iconName = "errorIcon"
                case .warning: iconName = "warningIcon"
                default: iconName = "messageIcon"
                }
                return UIImage(named: iconName, in: Bundle(for: type(of: self)), compatibleWith: nil)
            }
        }()

        if let icon = icon {
            iconImageView.image = icon

            addSubview(iconImageView)
            addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: NotificationLayout.iconSize.width))
            addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: NotificationLayout.iconSize.height))
            addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        }

        titleLabel.text = title
        addSubview(titleLabel)
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            addSubview(subtitleLabel)

            addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: NotificationLayout.labelVerticalPadding))
            
            addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: NotificationLayout.labelVerticalPadding/2))
            addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subtitleLabel, attribute: .bottom, multiplier: 1, constant: NotificationLayout.labelVerticalPadding))
            addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 0))
        } else {
            addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        }

        var accessoryView: UIView?
        switch accessoryType {
        case .none:
            break
        case .disclosureIndicator(_):
            tapAction = #selector(notificationViewDisclosureIndicatorTapped)
            let disclosureIndicator = UIImage(named: "disclosureIndicator", in: Bundle(for: type(of: self)), compatibleWith: nil)
            let imageView = UIImageView(image: disclosureIndicator)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            accessoryView = imageView
        case .custom(let view):
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            accessoryView = view
        }

        if let accessoryView = accessoryView {
            addConstraint(NSLayoutConstraint(item: accessoryView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: accessoryView.frame.width))
            addConstraint(NSLayoutConstraint(item: accessoryView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: accessoryView.frame.height))
            addConstraint(NSLayoutConstraint(item: accessoryView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        }

        var views: [String: Any] = ["titleLabel": titleLabel]
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
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(horizontalFormat)-|", options: [], metrics: nil, views: views))
    }

    fileprivate func configureGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: tapAction)
        let swipeGesture: UISwipeGestureRecognizer = {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(notificationViewSwiped))
            switch position! {
            case .top, .navBar: swipeGesture.direction = .up
            case .bottom: swipeGesture.direction = .down
            }
            return swipeGesture
        }()
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(swipeGesture)
    }

    @objc func notificationViewTapped() {
        dismiss()
    }

    @objc func notificationViewSwiped() {
        dismiss()
    }

    @objc func notificationViewDisclosureIndicatorTapped() {
        switch accessoryType {
        case .disclosureIndicator(let action):
            action()
        default:
            break
        }
    }

    @objc func dismissTimerInvocation(_ timer: Timer) {
        dismiss()
    }
    
    private var viewHeight: CGFloat {
        if self.subtitle != nil {
            return NotificationLayout.notificationMaxHeight
        }
        return NotificationLayout.notificationHeight
    }
}

public extension NotificationView {
    // MARK: - Life cycle
    func show(withDuration duration: TimeInterval = 0.5, completion: (() -> ())? = nil) {
        func show() {
            switch position! {
            case .top, .bottom:
                alpha = 1
                UIWindow.notificationWindow?.addSubview(self)
            case .navBar(let navigationController):
                alpha = 0
                navigationController.view.insertSubview(self, belowSubview: navigationController.navigationBar)
            }

            guard let superview = superview else {
                print("Show notification error: can not find a window to show notification")
                return
            }

            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: NotificationLayout.notificationMaxHeight))
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: NotificationLayout.notificationHeight))
            
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: NotificationLayout.notificationMaxWidth))
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0))
            let leadingSpace = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: NotificationLayout.notificationSpacing)
            let trailingSpace = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: -NotificationLayout.notificationSpacing)
            leadingSpace.priority = .notificationPadding
            trailingSpace.priority = .notificationPadding
            superview.addConstraints([leadingSpace, trailingSpace])

            // Prepare for display
            switch position! {
            case .top:
                verticalPositionConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: -(NotificationLayout.notificationSpacing + viewHeight))
            case .bottom:
                verticalPositionConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: NotificationLayout.notificationSpacing + viewHeight)
            case .navBar(let navigationController):
                let isNavBarHidden = navigationController.navigationBar.isHidden || navigationController.isNavigationBarHidden
                if isNavBarHidden {
                    verticalPositionConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: navigationController.view, attribute: .top, multiplier: 1, constant: -(NotificationLayout.notificationSpacing + viewHeight))
                } else {
                    verticalPositionConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: navigationController.navigationBar, attribute: .bottom, multiplier: 1, constant: -(NotificationLayout.notificationSpacing + viewHeight))
                }
            }
            superview.addConstraint(verticalPositionConstraint)
            superview.layoutIfNeeded()

            NotificationView.delegate?.willShowNotificationView(self)

            // Move to display position
            switch self.position! {
            case .top:
                if #available(iOS 11.0, *) {
                    self.verticalPositionConstraint.constant = NotificationLayout.notificationSpacing + safeAreaInsets.top
                } else {
                    self.verticalPositionConstraint.constant = NotificationLayout.notificationSpacing
                }
            case .navBar(_):
                self.verticalPositionConstraint.constant = NotificationLayout.notificationSpacing
            case .bottom:
                if #available(iOS 11.0, *) {
                    self.verticalPositionConstraint.constant = -NotificationLayout.notificationSpacing - safeAreaInsets.bottom
                } else {
                    self.verticalPositionConstraint.constant = -NotificationLayout.notificationSpacing
                }
            }

            isAnimating = true
            NotificationView.sharedNotification = self
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [.allowAnimatedContent, .beginFromCurrentState], animations: {
                switch self.position! {
                case .navBar(_): self.alpha = 1
                default: break
                }
                superview.layoutIfNeeded()
                }, completion: { (finished) in
                    DispatchQueue.main.async {
                        self.isAnimating = false
                        self.dismissTimer = Timer.scheduledTimer(timeInterval: self.duration, target: self, selector: #selector(self.dismissTimerInvocation(_:)), userInfo: nil, repeats: false)
                        NotificationView.delegate?.didShowNotificationView(self)

                        completion?()
                    }
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
                sharedNotification.dismiss(withDuration: 0.12, completion: {
                    show()
                })
            }
        } else {
            show()
        }
    }

    func dismiss(withDuration duration: TimeInterval = 0.4, completion: (() -> ())? = nil) {
        let shouldDismissNotification = NotificationView.delegate?.shouldDismissNotificationView(self) ?? true
        guard shouldDismissNotification else {
            return
        }

        guard let superview = superview else {
            return
        }

        NotificationView.delegate?.willDismissNotificationView(self)

        // Move to dismiss position
        switch position! {
        case .top, .navBar(_):
            verticalPositionConstraint.constant = -(NotificationLayout.notificationSpacing + viewHeight)
        case .bottom:
            verticalPositionConstraint.constant = NotificationLayout.notificationSpacing + viewHeight
        }

        isAnimating = true
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [.allowAnimatedContent, .beginFromCurrentState], animations: {
            switch self.position! {
            case .navBar(_): self.alpha = 0
            default: break
            }
            superview.layoutIfNeeded()
            }) { (finished) in
                DispatchQueue.main.async {
                    self.isAnimating = false
                    self.removeFromSuperview()
                    NotificationView.sharedNotification = nil
                    self.dismissTimer?.invalidate()
                    self.dismissTimer = nil
                    NotificationView.delegate?.didDismissNotificationView(self)

                    completion?()
                }
        }
    }
}
