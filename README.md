#NotificationView
Easy to use and customizable messages/notifications for iOS applications.

![Example](Gif/NotificationViewExample.gif "NotificationViewExample")

##How To Get Started
###Carthage
Specify "NotificationView" in your ```Cartfile```:
```ogdl 
github "teambition/NotificationView"
```

###Usage
##### Style
Four default icon styles available, and custom icon is supported certainly.
```swift
enum NotificationViewStyle {
    case success
    case error
    case message
    case warning
    case custom(UIImage?)
}
```

##### Position
```swift
enum NotificationViewPosition {
    case top
    case bottom
    case navBar(UINavigationController)
}
```
For position ```navBar```, an UINavigationController instance is needed for displaying the notification.

##### Accessory Type
```swift
enum NotificationViewAccessoryType {
    case none
    case disclosureIndicator(() -> ())
    case custom(UIView)
}
```
For accessory type ```disclosureIndicator```, a disclosure indicator will be displayed in the right side of the notification, which indicates that tapping the notification triggers an action associated with the value of the ```accessoryType``` property.

For accessory type ```custom```, the given associated view will be used for the right accessory view of notification.

##### Show Notification
```swift
static func showNotification(at position: NotificationViewPosition = default, style: NotificationViewStyle, title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }

static func showSuccess(at position: NotificationViewPosition = default, title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }

static func showError(at position: NotificationViewPosition = default, title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }

static func showMessage(at position: NotificationViewPosition = default, title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }

static func showWarning(at position: NotificationViewPosition = default, title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }
```

For position ```navBar```, there is a convenient way to show notification, you can call these functions of ```UINavigationController```:
```swift
extension UINavigationController {
    func showNotification(style: NotificationViewStyle, title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }

    func showSuccess(title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }

    func showError(title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }

    func showMessage(title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }

    func showWarning(title: String?, subtitle: String?, accessoryType: NotificationViewAccessoryType = default) { }
}
```

#####  Implement the delegate if needed
```swift
func shouldShowNotificationView(_ notificationView: NotificationView) -> Bool {
    // default is true
}

func willShowNotificationView(_ notificationView: NotificationView) {
    // do something
}

func didShowNotificationView(_ notificationView: NotificationView) {
    // do something
}

func shouldDismissNotificationView(_ notificationView: NotificationView) -> Bool {
    // default is true
}

func willDismissNotificationView(_ notificationView: NotificationView) {
    // do something
}

func didDismissNotificationView(_ notificationView: NotificationView) {
    // do something
}
```

## Minimum Requirement
iOS 8.0

## Release Notes
* [Release Notes](https://github.com/teambition/NotificationView/releases)

## License
NotificationView is released under the MIT license. See [LICENSE](https://github.com/teambition/NotificationView/blob/master/LICENSE.md) for details.

## More Info
Have a question? Please [open an issue](https://github.com/teambition/NotificationView/issues/new)!
