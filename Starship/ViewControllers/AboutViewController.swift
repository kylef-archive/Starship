//
//  AboutViewController.swift
//  Starship
//
//  Created by Kyle Fuller on 01/07/2015.
//  Copyright (c) 2015 Kyle Fuller. All rights reserved.
//

import UIKit
import VTAcknowledgementsViewController


class AboutViewController : UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "About"
  }

  func presentAcknowledgements() {
    let acknowledgementsPath = NSBundle.mainBundle().pathForResource("Pods-Starship-acknowledgements", ofType: "plist")
    let viewController = VTAcknowledgementsViewController(acknowledgementsPlistPath: acknowledgementsPath)
    navigationController?.pushViewController(viewController!, animated: true)
  }

  // MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      return versionCell()
    case 1:
      return acknowledgementsCell()
    default:
      fatalError("Unknown Index")
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0:
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    case 1:
      presentAcknowledgements()
    default:
      fatalError("Unknown Index")
    }
  }

  func versionCell() -> UITableViewCell {
    let cell = UITableViewCell(style: .Value1, reuseIdentifier: "VersionCell")
    let infoDictionary = NSBundle.mainBundle().infoDictionary!
    let shortVersion = infoDictionary["CFBundleShortVersionString"] as! String
    let build = infoDictionary["CFBundleVersion"] as! String
    cell.textLabel?.text = "Version"
    cell.detailTextLabel?.text = "\(shortVersion) (\(build))"
    cell.selectionStyle = .None
    return cell
  }

  func acknowledgementsCell() -> UITableViewCell {
    let cell = UITableViewCell(style: .Default, reuseIdentifier: "AcknowledgementsCell")
    cell.textLabel?.text = "Acknowledgements"
    cell.accessoryType = .DisclosureIndicator
    return cell
  }
}