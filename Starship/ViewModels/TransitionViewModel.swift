//
//  TransitionViewModel.swift
//  Starship
//
//  Created by Kyle Fuller on 01/07/2015.
//  Copyright (c) 2015 Kyle Fuller. All rights reserved.
//

import Hyperdrive
import Representor



class TransitionViewModel {
  let hyperdrive:Hyperdrive
  let transition:HTTPTransition

  private var parameters = [String:String]()
  private var attributes = [String:String]()

  init(hyperdrive:Hyperdrive, transition:HTTPTransition) {
    self.hyperdrive = hyperdrive
    self.transition = transition
  }

  var numberOfParameters:Int {
    return transition.parameters.count
  }

  var numberOfAttributes:Int {
    return transition.attributes.count
  }

  func titleForParameter(index:Int) -> String {
    return transition.parameters.keys.array[index]
  }

  func valueForParameter(index:Int) -> String? {
    let current = parameters[titleForParameter(index)]
    return current ?? transition.parameters.values.array[index].value as? String
  }

  func setValueForParameter(index:Int, value:String) {
    parameters[titleForParameter(index)] = value
  }

  func titleForAttribute(index:Int) -> String {
    return transition.attributes.keys.array[index]
  }

  func valueForAttribute(index:Int) -> String? {
    let current = parameters[titleForAttribute(index)]
    return current ?? transition.attributes.values.array[index].value as? String
  }

  func setValueForAttribute(index:Int, value:String) {
    attributes[titleForAttribute(index)] = value
  }

  var isValid:Bool {
    return true
  }

  func perform(completion:((ResourceViewModelResult) -> ())) {
    hyperdrive.request(transition, parameters: parameters, attributes: attributes) { result in
      switch result {
      case .Success(let representor):
        let viewModel = ResourceViewModel(hyperdrive: self.hyperdrive, representor: representor)
        completion(.Success(viewModel))
      case .Failure(let error):
        completion(.Failure(error))
      }
    }
  }
}
