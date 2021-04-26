//
//  TabBarController.swift
//  Whitehouse Petitions
//
//  Created by Anna Udobnaja on 26.04.2021.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let recentsNavigationController = UINavigationController(rootViewController: ViewController())
        let topRatedNavigationController = UINavigationController(rootViewController: ViewController())

        recentsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        topRatedNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)

        viewControllers = [recentsNavigationController, topRatedNavigationController]

        // Do any additional setup after loading the view.
    }
}
