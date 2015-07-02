//
//  StarshipViewModel.swift
//  Starship
//
//  Created by Kyle Fuller on 01/07/2015.
//  Copyright (c) 2015 Kyle Fuller. All rights reserved.
//

import Foundation
import Hyperdrive


enum StarshipResult {
  case Success(ResourceViewModel)
  case Failure(NSError)
}


class StarshipViewModel {
  // MARK: Entry

  func enter(# uri:String, completion:(StarshipResult -> ())) {
    let hyperdrive = Hyperdrive()
    hyperdrive.enter(uri) { result in
      switch result {
      case .Success(let representor):
        let viewModel = ResourceViewModel(hyperdrive: hyperdrive, representor: representor)
        completion(.Success(viewModel))
      case .Failure(let error):
        completion(.Failure(error))
      }
    }
  }

  func enter(# apiary:String, completion:(StarshipResult -> ())) {
    HyperBlueprint.enter(apiary: apiary) { result in
      switch result {
      case .Success(let hyperdrive, let representor):
        let viewModel = ResourceViewModel(hyperdrive: hyperdrive, representor: representor)
        completion(.Success(viewModel))
      case .Failure(let error):
        completion(.Failure(error))
      }
    }
  }

  // MARK: Examples

  private var examples:[(title:String, uri:String)] {
    return [
      (title: "Polls", uri: "https://polls.apiblueprint.org/"),
      (title: "Maze", uri: "https://maze-server.herokuapp.com/"),
      (title: "FizzBuzz", uri: "https://fizzbuzzaas.herokuapp.com/"),
    ]
  }

  var numberOfExamples:Int {
    return examples.count
  }

  func titleForExample(index:Int) -> String {
    return examples[index].title
  }

  func uriForExample(index:Int) -> String {
    return examples[index].uri
  }

  func enterExample(index:Int, completion:(StarshipResult -> ())) {
    enter(uri: uriForExample(index), completion: completion)
  }
}
