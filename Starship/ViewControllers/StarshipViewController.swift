//
//  StarshipViewController.swift
//  Starship
//
//  Created by Kyle Fuller on 01/07/2015.
//  Copyright (c) 2015 Kyle Fuller. All rights reserved.
//

import UIKit
import SVProgressHUD
import JFTextFieldTableCell


enum StarshipSection : Int {
  case Entry
  case Examples
}

class StarshipViewController : UITableViewController {
  let viewModel = StarshipViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Starship"

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "About", style: .Plain, target: self, action: "presentAbout")
  }

  func presentAbout() {
    let viewController = AboutViewController(style: .Grouped)
    navigationController?.pushViewController(viewController, animated: true)
  }

  func resultHandler(result:StarshipResult) {
    SVProgressHUD.dismiss()

    switch result {
    case .Success(let viewModel):
      let viewController = ResourceViewController(style: .Grouped)
      viewController.viewModel = viewModel
      self.navigationController?.pushViewController(viewController, animated: true)
    case .Failure(let error):
      let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
      self.presentViewController(alertController, animated: true, completion: nil)
    }
  }

  // MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch StarshipSection(rawValue: section)! {
    case .Entry:
      return nil
    case .Examples:
      return "Examples"
    }
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch StarshipSection(rawValue: section)! {
    case .Entry:
      return 2
    case .Examples:
      return viewModel.numberOfExamples
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch StarshipSection(rawValue: indexPath.section)! {
    case .Entry:
      switch indexPath.row {
      case 0:
        return inputURLCell(tableView)
      case 1:
        return inputApiaryCell(tableView)
      default:
        fatalError("Unhandled Index")
      }
    case .Examples:
      return cellForExample(tableView, index: indexPath.row)
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch StarshipSection(rawValue: indexPath.section)! {
    case .Entry:
      break

    case .Examples:
      SVProgressHUD.showWithMaskType(.Gradient)
      viewModel.enterExample(indexPath.row, completion: resultHandler)
    }
  }

  func inputURLCell(tableView:UITableView) -> UITableViewCell {
    let cell = JFTextFieldTableCell(style: .Default, reuseIdentifier: "Cell")
    cell.textField.placeholder = "URL to Hypermedia API"
    cell.textField.keyboardType = .URL
    cell.textField.returnKeyType = .Go
    cell.textFieldShouldReturn = { [unowned self] textField in
      SVProgressHUD.showWithMaskType(.Gradient)
      self.viewModel.enter(uri: textField.text, completion: self.resultHandler)
      return true
    }
    return cell
  }

  func inputApiaryCell(tableView:UITableView) -> UITableViewCell {
    let cell = JFTextFieldTableCell(style: .Default, reuseIdentifier: "Cell")
    cell.textField.placeholder = "Apiary Domain"
    cell.textField.keyboardType = .URL
    cell.textField.returnKeyType = .Go
    cell.textFieldShouldReturn = { [unowned self] textField in
      SVProgressHUD.showWithMaskType(.Gradient)
      self.viewModel.enter(apiary: textField.text, completion: self.resultHandler)
      return true
    }
    return cell
  }

  func cellForExample(tableView:UITableView, index:Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Example") as? UITableViewCell ?? UITableViewCell(style: .Value1, reuseIdentifier: "Example")
    cell.textLabel?.text = viewModel.titleForExample(index)
    cell.detailTextLabel?.text = viewModel.uriForExample(index)
    return cell
  }
}
