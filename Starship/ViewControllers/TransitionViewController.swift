//
//  TransitionViewController.swift
//  Starship
//
//  Created by Kyle Fuller on 01/07/2015.
//  Copyright (c) 2015 Kyle Fuller. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftForms


enum TransitionSection : Int {
  case Parameters
  case Attributes
}


class TransitionViewController : FormViewController {
  var viewModel:TransitionViewModel? {
    didSet {
      if isViewLoaded() {
        updateState()
        tableView.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go", style: .Plain, target: self, action: "perform")
    updateState()
    super.viewDidLoad()
  }

  func updateState() {
    navigationItem.rightBarButtonItem?.enabled = viewModel?.isValid ?? false

    let form = FormDescriptor()

    if viewModel?.numberOfParameters > 0 {
      let section = FormSectionDescriptor()
      section.headerTitle = "Parameters"

      for index in (0..<viewModel!.numberOfParameters) {
        let title = viewModel!.titleForParameter(index)
        let row = FormRowDescriptor(tag: title, rowType: .Text, title: title)
        let updateClosure:UpdateClosure = { [unowned self] descriptor in
          self.viewModel?.setValueForParameter(index, value: descriptor.value as? String ?? "")
        }
        row.configuration[FormRowDescriptor.Configuration.DidUpdateClosure] = updateClosure
        section.addRow(row)
      }

      form.addSection(section)
    }

    if viewModel?.numberOfAttributes > 0 {
      let section = FormSectionDescriptor()
      section.headerTitle = "Attributes"

      for index in (0..<viewModel!.numberOfAttributes) {
        let title = viewModel!.titleForAttribute(index)
        let row = FormRowDescriptor(tag: title, rowType: .Text, title: title)
        let updateClosure:UpdateClosure = { [unowned self] descriptor in
          self.viewModel?.setValueForAttribute(index, value: descriptor.value as? String ?? "")
        }
        row.configuration[FormRowDescriptor.Configuration.DidUpdateClosure] = updateClosure
        section.addRow(row)
      }

      form.addSection(section)
    }

    self.form = form
  }

  func perform() {
    SVProgressHUD.showWithMaskType(.Gradient)

    viewModel?.perform { result in
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
  }
}
