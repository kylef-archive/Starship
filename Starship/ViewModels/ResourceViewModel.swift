//
//  ResourceViewModel.swift
//  Starship
//
//  Created by Kyle Fuller on 01/07/2015.
//  Copyright (c) 2015 Kyle Fuller. All rights reserved.
//

import Foundation
import Representor
import Hyperdrive


enum ResourceViewModelResult {
  case Success(ResourceViewModel)
  case Failure(NSError)
}

class ResourceViewModel {
  // MARK: RepresentorViewModel

  let hyperdrive:Hyperdrive
  private(set) var representor:Representor<HTTPTransition>

  init(hyperdrive:Hyperdrive, representor:Representor<HTTPTransition>) {
    self.hyperdrive = hyperdrive
    self.representor = representor
  }

  var canReload:Bool {
    return self.representor.transitions["self"] != nil
  }

  func reload(completion:((Result) -> ())) {
    if let uri = self.representor.transitions["self"] {
      hyperdrive.request(uri) { result in
        switch result {
        case .Success(let representor):
          self.representor = representor
        case .Failure(let error):
          break
        }

        completion(result)
      }
    }
  }

  // MARK: Private

  private var attributes:[(key:String, value:AnyObject)] {
    return map(representor.attributes) { (key, value) in
      return (key: key, value: value)
    }
  }

  private var embeddedResources:[(relation:String, representor:Representor<HTTPTransition>)] {
    return reduce(representor.representors, []) { (accumulator, resources) in
      let name = resources.0

      return accumulator + map(resources.1) { representor in
        return (relation: name, representor: representor)
      }
    }
  }

  private var transitions:[(relation:String, transition:HTTPTransition)] {
    return filter(representor.transitions) { (relation, transition) in
      return relation != "self"
    }.map { (relation, transition) in
      return (relation: relation, transition: transition)
    }
  }

  // MARK: Attributes

  var numberOfAttributes:Int {
    return representor.attributes.count
  }

  func titleForAttribute(index:Int) -> String {
    return attributes[index].key
  }

  func valueForAttribute(index:Int) -> String {
    return "\(attributes[index].value)"
  }

  // MARK: Embedded Resources

  var numberOfEmbeddedResources:Int {
    return embeddedResources.count
  }

  func titleForEmbeddedResource(index:Int) -> String {
    return embeddedResources[index].relation
  }

  func viewModelForEmbeddedResource(index:Int) -> ResourceViewModel {
    let representor = embeddedResources[index].representor
    return ResourceViewModel(hyperdrive: hyperdrive, representor: representor)
  }

  // MARK: Transitions

  var numberOfTransitions:Int {
    return transitions.count
  }

  func titleForTransition(index:Int) -> String {
    return transitions[index].relation
  }

  func performTransition(index:Int, completion:(ResourceViewModelResult -> ())) {
    hyperdrive.request(transitions[index].transition) { result in
      switch result {
      case .Success(let representor):
        completion(.Success(ResourceViewModel(hyperdrive: self.hyperdrive, representor: representor)))
      case .Failure(let error):
        completion(.Failure(error))
      }
    }
  }
}
