//
//  ExampleViewController.swift
//  NotificationViewExample
//
//  Created by Xin Hong on 16/5/8.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import NotificationView

private let kNotificationViewExampleCellID = "NotificationViewExampleCell"
private let kNotificationViewStyles: [NotificationViewStyle] = [.Success, .Error, .Message, .Warning, .Custom(UIImage(named: "customIcon"))]
private let kNotificationViewStyleStrings = ["Success", "Error", "Message", "Warning", "Custom Icon"]
private let kNotificationViewPositionStrings = ["Top", "Bottom", "NavBar"]
private let kNotificationViewAccessoryTypeStrings = ["None", "Disclosure Indicator", "Button", "Custom Accessory View"]

class ExampleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var style: NotificationViewStyle = .Success
    private var position: NotificationViewPosition = .Top
    private var accessoryType: NotificationViewAccessoryType = .None
    private var styleIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    private var positionIndexPath = NSIndexPath(forRow: 0, inSection: 1)
    private var accessoryIndexPath = NSIndexPath(forRow: 0, inSection: 2)
    private var notificationCount = 0

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Helper
    private func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "NotificationView Example"
        tableView.tintColor = UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Actions
    @IBAction func showNotificationButtonTapped(sender: UIButton) {
        notificationCount += 1
        let title = "Show notification \(notificationCount) successfully! You can tap the notification to dismiss."
        let subtitle = "You can tap the notification to dismiss."
        NotificationView.showNotification(position,
                                          style: style,
                                          title: title,
                                          subtitle: subtitle,
                                          accessoryType: accessoryType)
    }

    func doneButtonTapped(sender: UIButton) {
        let alert = UIAlertController(title: "Done button tapped!", message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension ExampleViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source and delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return kNotificationViewStyleStrings.count
        case 1: return kNotificationViewPositionStrings.count
        case 2: return kNotificationViewAccessoryTypeStrings.count
        default: return 0
        }

    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Style"
        case 1: return "Position"
        case 2: return "Accessory"
        default: return nil
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kNotificationViewExampleCellID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: kNotificationViewExampleCellID)
        }
        switch indexPath.section {
        case 0:
            cell?.accessoryType = indexPath == styleIndexPath ? .Checkmark : .None
            cell?.textLabel?.text = kNotificationViewStyleStrings[indexPath.row]
        case 1:
            cell?.accessoryType = indexPath == positionIndexPath ? .Checkmark : .None
            cell?.textLabel?.text = kNotificationViewPositionStrings[indexPath.row]
        case 2:
            cell?.accessoryType = indexPath == accessoryIndexPath ? .Checkmark : .None
            cell?.textLabel?.text = kNotificationViewAccessoryTypeStrings[indexPath.row]
        default: break
        }
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if styleIndexPath == indexPath {
                return
            }

            style = kNotificationViewStyles[indexPath.row]
            tableView.cellForRowAtIndexPath(styleIndexPath)?.accessoryType = .None
            styleIndexPath = indexPath
            tableView.cellForRowAtIndexPath(styleIndexPath)?.accessoryType = .Checkmark
        case 1:
            if positionIndexPath == indexPath {
                return
            }

            switch indexPath.row {
            case 0:
                position = .Top
            case 1:
                position = .Bottom
            case 2:
                position = .NavBar(navigationController!)
            default:
                break
            }
            tableView.cellForRowAtIndexPath(positionIndexPath)?.accessoryType = .None
            positionIndexPath = indexPath
            tableView.cellForRowAtIndexPath(positionIndexPath)?.accessoryType = .Checkmark
        case 2:
            if accessoryIndexPath == indexPath {
                return
            }

            switch indexPath.row {
            case 0:
                accessoryType = .None
            case 1:
                accessoryType = .DisclosureIndicator({
                    let alert = UIAlertController(title: "Disclosure Indicator", message: nil, preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            case 2:
                let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 90, height: 35)))
                button.layer.cornerRadius = 6
                button.backgroundColor = UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)
                button.setTitle("Done", forState: .Normal)
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                button.addTarget(self, action: #selector(doneButtonTapped(_:)), forControlEvents: .TouchUpInside)
                button.titleLabel?.font = UIFont.systemFontOfSize(16)
                accessoryType = .Custom(button)
            case 3:
                let accessoryView = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 130, height: 35)))
                accessoryView.backgroundColor = UIColor.cyanColor()
                accessoryView.layer.cornerRadius = 7
                accessoryView.clipsToBounds = true
                accessoryView.text = "Accessory View"
                accessoryView.textColor = UIColor.redColor()
                accessoryView.font = UIFont.systemFontOfSize(15)
                accessoryView.textAlignment = .Center
                accessoryType = .Custom(accessoryView)
            default:
                break
            }
            tableView.cellForRowAtIndexPath(accessoryIndexPath)?.accessoryType = .None
            accessoryIndexPath = indexPath
            tableView.cellForRowAtIndexPath(accessoryIndexPath)?.accessoryType = .Checkmark
        default:
            break
        }
    }
}
