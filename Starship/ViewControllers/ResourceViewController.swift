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

    title = viewModel?.title ?? "Resource"

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
      let title = viewModel?.titleForAttribute(indexPath.row)
      let value = viewModel?.valueForAttribute(indexPath.row)
      let alertController = UIAlertController(title: title, message: value, preferredStyle: .Alert)
      let action = UIAlertAction(title: "OK", style: .Default) { action in
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
      }
      alertController.addAction(action)
      presentViewController(alertController, animated: true, completion: nil)
    case .EmbeddedResources:
      let viewController = ResourceViewController(style: .Grouped)
      viewController.viewModel = viewModel?.viewModelForEmbeddedResource(indexPath.row)
      self.navigationController?.pushViewController(viewController, animated: true)
    case .Transitions:
      if !presentTransition(indexPath.row) {
        performTransition(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
      }
    }
  }

  // MARK: UITableView

  func cellForAttribute(tableView:UITableView, index:Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Attribute") ?? UITableViewCell(style: .Value1, reuseIdentifier: "Attribute")
    cell.textLabel?.text = viewModel?.titleForAttribute(index)
    cell.detailTextLabel?.text = viewModel?.valueForAttribute(index)
    return cell
  }

  func cellForEmbeddedResource(tableView:UITableView, index:Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Resource") ?? UITableViewCell(style: .Value1, reuseIdentifier: "Resource")

    if let title = viewModel?.titleForEmbeddedResource(index) {
      cell.textLabel?.text = title
      cell.detailTextLabel?.text = viewModel?.relationForEmbeddedResource(index)
    } else {
      cell.textLabel?.text = viewModel?.relationForEmbeddedResource(index)
      cell.detailTextLabel?.text = nil
    }

    return cell
  }

  func cellForTransition(tableView:UITableView, index:Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Transition") ?? UITableViewCell(style: .Default, reuseIdentifier: "Transition")
    cell.textLabel?.text = viewModel?.titleForTransition(index)
    return cell
  }

  func presentTransition(index:Int) -> Bool {
    if let viewModel = viewModel?.viewModelForTransition(index) {
      let viewController = TransitionViewController(style: .Grouped)
      viewController.title = self.viewModel?.titleForTransition(index)
      viewController.viewModel = viewModel
      navigationController?.pushViewController(viewController, animated: true)
      return true
    }

    return false
  }

  func performTransition(index:Int) {
    SVProgressHUD.showWithMaskType(.Gradient)

    viewModel?.performTransition(index) { result in
      SVProgressHUD.dismiss()

      switch result {
      case .Success(let viewModel):
        let viewController = ResourceViewController(style: .Grouped)
        viewController.viewModel = viewModel
        self.navigationController?.pushViewController(viewController, animated: true)
      case .Refresh:
        self.updateState()
      case .Failure(let error):
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Re-try", style: .Default) { action in
          self.performTransition(index)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
      }
    }
  }
}
