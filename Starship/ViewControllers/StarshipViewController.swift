//
//  StarshipViewController.swift
//  Starship
//
//  Created by Kyle Fuller on 01/07/2015.
//  Copyright (c) 2015 Kyle Fuller. All rights reserved.
//

import UIKit
import SVProgressHUD


enum StarshipSection : Int {
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

  // MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch StarshipSection(rawValue: section)! {
    case .Examples:
      return "Examples"
    }
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch StarshipSection(rawValue: section)! {
    case .Examples:
      return viewModel.numberOfExamples
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return cellForExample(tableView, index: indexPath.row)
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch StarshipSection(rawValue: indexPath.section)! {
    case .Examples:
      SVProgressHUD.showWithMaskType(.Gradient)
      viewModel.enterExample(indexPath.row) { result in
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
    }
  }

  func cellForExample(tableView:UITableView, index:Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Example") as? UITableViewCell ?? UITableViewCell(style: .Value1, reuseIdentifier: "Example")
    cell.textLabel?.text = viewModel.titleForExample(index)
    cell.detailTextLabel?.text = viewModel.uriForExample(index)
    return cell
  }
}
