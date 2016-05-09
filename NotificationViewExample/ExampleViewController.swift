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
private let kNotificationViewStyles: [NotificationViewStyle] = [.Simple, .Success, .Error, .Message, .Warning]
private let kNotificationViewStyleStrings = ["Simple", "Success", "Error", "Message", "Warning"]
private let kNotificationViewPositionStrings = ["Top", "Bottom", "NavBar"]
private let kNotificationViewAccessoryTypeStrings = ["None", "DisclosureIndicator", "Button"]

class ExampleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var style: NotificationViewStyle = .Success
    private var position: NotificationViewPosition = .Bottom
    private var accessoryType: NotificationViewAccessoryType = .None
    private var notificationCount = 0

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Helper
    private func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "NotificationView"
        tableView.tableFooterView = UIView()
    }

    // MARK: - Actions
    @IBAction func showNotificationButtonTapped(sender: UIButton) {
        notificationCount += 1
        let notificationView = NotificationView(position: position,
                                                style: style,
                                                title: "Show notification \(notificationCount) successfully!",
                                                subtitle: "You can tap the notification to dismiss.",
                                                accessoryType: accessoryType,
                                                accessoryView: nil)
        notificationView.show()
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
        case 2: return "Accessory Type"
        default: return nil
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kNotificationViewExampleCellID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: kNotificationViewExampleCellID)
        }
        switch indexPath.section {
        case 0: cell?.textLabel?.text = kNotificationViewStyleStrings[indexPath.row]
        case 1: cell?.textLabel?.text = kNotificationViewPositionStrings[indexPath.row]
        case 2: cell?.textLabel?.text = kNotificationViewAccessoryTypeStrings[indexPath.row]
        default: break
        }
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
