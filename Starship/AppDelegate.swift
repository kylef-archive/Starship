//
//  AppDelegate.swift
//  Starship
//
//  Created by Kyle Fuller on 19/04/2015.
//  Copyright (c) 2015 Kyle Fuller. All rights reserved.
//

import UIKit
import Hyperdrive
import Representor


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window.rootViewController = UINavigationController(rootViewController: StarshipViewController(style: .Grouped))
    self.window = window
    window.makeKeyAndVisible()
    return true
  }
}
