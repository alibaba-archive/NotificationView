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
private let kNotificationViewStyles: [NotificationViewStyle] = [.success, .error, .message, .warning, .custom(UIImage(named: "customIcon"))]
private let kNotificationViewStyleStrings = ["Success", "Error", "Message", "Warning", "Custom Icon"]
private let kNotificationViewPositionStrings = ["Top", "Bottom", "NavBar"]
private let kNotificationViewAccessoryTypeStrings = ["None", "Disclosure Indicator", "Button", "Custom Accessory View"]

class ExampleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    fileprivate var style: NotificationViewStyle = .success
    fileprivate var position: NotificationViewPosition = .top
    fileprivate var accessoryType: NotificationViewAccessoryType = .none
    fileprivate var styleIndexPath = IndexPath(row: 0, section: 0)
    fileprivate var positionIndexPath = IndexPath(row: 0, section: 1)
    fileprivate var accessoryIndexPath = IndexPath(row: 0, section: 2)
    fileprivate var notificationCount = 0

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Helper
    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "NotificationView Example"
        tableView.tintColor = UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Actions
    @IBAction func showNotificationButtonTapped(_ sender: UIButton) {
        notificationCount += 1
        let title = "Show notification \(notificationCount) successfully! You can tap the notification to dismiss."
        let subtitle = "You can tap the notification to dismiss."
        NotificationView.showNotification(at: position,
                                          style: style,
                                          title: title,
                                          subtitle: subtitle,
                                          accessoryType: accessoryType)
    }

    func doneButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Done button tapped!", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ExampleViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source and delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return kNotificationViewStyleStrings.count
        case 1: return kNotificationViewPositionStrings.count
        case 2: return kNotificationViewAccessoryTypeStrings.count
        default: return 0
        }

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Style"
        case 1: return "Position"
        case 2: return "Accessory"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kNotificationViewExampleCellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: kNotificationViewExampleCellID)
        }
        switch indexPath.section {
        case 0:
            cell?.accessoryType = indexPath == styleIndexPath ? .checkmark : .none
            cell?.textLabel?.text = kNotificationViewStyleStrings[indexPath.row]
        case 1:
            cell?.accessoryType = indexPath == positionIndexPath ? .checkmark : .none
            cell?.textLabel?.text = kNotificationViewPositionStrings[indexPath.row]
        case 2:
            cell?.accessoryType = indexPath == accessoryIndexPath ? .checkmark : .none
            cell?.textLabel?.text = kNotificationViewAccessoryTypeStrings[indexPath.row]
        default: break
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if styleIndexPath == indexPath {
                return
            }

            style = kNotificationViewStyles[indexPath.row]
            tableView.cellForRow(at: styleIndexPath)?.accessoryType = .none
            styleIndexPath = indexPath
            tableView.cellForRow(at: styleIndexPath)?.accessoryType = .checkmark
        case 1:
            if positionIndexPath == indexPath {
                return
            }

            switch indexPath.row {
            case 0:
                position = .top
            case 1:
                position = .bottom
            case 2:
                position = .navBar(navigationController!)
            default:
                break
            }
            tableView.cellForRow(at: positionIndexPath)?.accessoryType = .none
            positionIndexPath = indexPath
            tableView.cellForRow(at: positionIndexPath)?.accessoryType = .checkmark
        case 2:
            if accessoryIndexPath == indexPath {
                return
            }

            switch indexPath.row {
            case 0:
                accessoryType = .none
            case 1:
                accessoryType = .disclosureIndicator({
                    let alert = UIAlertController(title: "Disclosure Indicator", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                })
            case 2:
                let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 90, height: 35)))
                button.layer.cornerRadius = 6
                button.backgroundColor = UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)
                button.setTitle("Done", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                accessoryType = .custom(button)
            case 3:
                let accessoryView = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 130, height: 35)))
                accessoryView.backgroundColor = UIColor.cyan
                accessoryView.layer.cornerRadius = 7
                accessoryView.clipsToBounds = true
                accessoryView.text = "Accessory View"
                accessoryView.textColor = UIColor.red
                accessoryView.font = UIFont.systemFont(ofSize: 15)
                accessoryView.textAlignment = .center
                accessoryType = .custom(accessoryView)
            default:
                break
            }
            tableView.cellForRow(at: accessoryIndexPath)?.accessoryType = .none
            accessoryIndexPath = indexPath
            tableView.cellForRow(at: accessoryIndexPath)?.accessoryType = .checkmark
        default:
            break
        }
    }
}
