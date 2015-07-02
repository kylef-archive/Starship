//
//  ResourceViewController.swift
//  Starship
//
//  Created by Kyle Fuller on 01/07/2015.
//  Copyright (c) 2015 Kyle Fuller. All rights reserved.
//

import UIKit
import SVProgressHUD


enum ResourceViewControllerSection {
  case Attributes
  case EmbeddedResources
  case Transitions
}

class ResourceViewController : UITableViewController {
  var viewModel:ResourceViewModel? {
    didSet {
      if isViewLoaded() {
        updateState()
      }
    }
  }

  var sections:[ResourceViewControllerSection] {
    var sections = [ResourceViewControllerSection]()

    if viewModel?.numberOfAttributes > 0 {
      sections.append(.Attributes)
    }

    if viewModel?.numberOfEmbeddedResources > 0 {
      sections.append(.EmbeddedResources)
    }

    if viewModel?.numberOfTransitions > 0 {
      sections.append(.Transitions)
    }

    return sections
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Resource"
    updateState()
  }

  func updateState() {
    if viewModel?.canReload ?? false {
      if refreshControl == nil {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action:Selector("reload"), forControlEvents:.ValueChanged)
      }
    } else {
      refreshControl = nil
    }

    tableView?.reloadData()
  }

  func reload() {
    if let viewModel = viewModel {
      viewModel.reload { result in
        self.refreshControl?.endRefreshing()
        self.updateState()
      }
    } else {
      refreshControl?.endRefreshing()
    }
  }

  // MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sections.count
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch sections[section] {
    case .Attributes:
      return "Attributes"
    case .EmbeddedResources:
      return "Embedded Resources"
    case .Transitions:
      return "Transitions"
    }
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch sections[section] {
    case .Attributes:
      return viewModel?.numberOfAttributes ?? 0
    case .EmbeddedResources:
      return viewModel?.numberOfEmbeddedResources ?? 0
    case .Transitions:
      return viewModel?.numberOfTransitions ?? 0
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch sections[indexPath.section] {
    case .Attributes:
      return cellForAttribute(tableView, index: indexPath.row)
    case .EmbeddedResources:
      return cellForEmbeddedResource(tableView, index: indexPath.row)
    case .Transitions:
      return cellForTransition(tableView, index: indexPath.row)
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch sections[indexPath.section] {
    case .Attributes:
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    case .EmbeddedResources:
      let viewController = ResourceViewController(style: .Grouped)
      viewController.viewModel = viewModel?.viewModelForEmbeddedResource(indexPath.row)
      self.navigationController?.pushViewController(viewController, animated: true)
    case .Transitions:
      SVProgressHUD.showWithMaskType(.Gradient)

      viewModel?.performTransition(indexPath.row) { result in
        SVProgressHUD.dismiss()

        switch result {
        case .Success(let viewModel):
          let viewController = ResourceViewController(style: .Grouped)
          viewController.viewModel = viewModel
          self.navigationController?.pushViewController(viewController, animated: true)
        case .Failure(let error):
          let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
          alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
          self.presentViewController(alertController, animated: true, completion: nil)
        }
      }

      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }

  // MARK: UITableView

  func cellForAttribute(tableView:UITableView, index:Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Attribute") as? UITableViewCell ?? UITableViewCell(style: .Value1, reuseIdentifier: "Attribute")
    cell.textLabel?.text = viewModel?.titleForAttribute(index)
    cell.detailTextLabel?.text = viewModel?.valueForAttribute(index)
    return cell
  }

  func cellForEmbeddedResource(tableView:UITableView, index:Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Resource") as? UITableViewCell ?? UITableViewCell(style: .Default, reuseIdentifier: "Resource")
    cell.textLabel?.text = viewModel?.titleForEmbeddedResource(index)
    return cell
  }

  func cellForTransition(tableView:UITableView, index:Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Transition") as? UITableViewCell ?? UITableViewCell(style: .Default, reuseIdentifier: "Transition")
    cell.textLabel?.text = viewModel?.titleForTransition(index)
    return cell
  }
}
