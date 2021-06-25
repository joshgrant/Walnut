//
//  RootController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/12/21.
//

import UIKit
import ProgrammaticUI

class RootController: TabBarController
{
    init(
        viewControllers: [UIViewController],
        delegate: TabBarControllerDelegate)
    {
        super.init(delegate: delegate)
        self.viewControllers = viewControllers
        self.view.backgroundColor = .orange
    }
    
    convenience init(viewControllers: [UIViewController])
    {
        let delegate = makeTabBarControllerDelegate()
        self.init(viewControllers: viewControllers, delegate: delegate)
    }
}

func makeTabBarViewControllers(context: Context) -> [UIViewController]
{
    let dashboardController = DashboardController(context: context)
    let dashboardNavigation = NavigationController(rootViewController: dashboardController)
    
    let libraryNavigation = NavigationController()
    let libraryController = LibraryController(context: context, navigationController: libraryNavigation)
    libraryNavigation.setViewControllers([libraryController], animated: false)
    
    let inboxController = InboxController.makeController()
    let inboxNavigation = NavigationController(rootViewController: inboxController)
    
    let settingsController = SettingsController.makeController()
    let settingsNavigation = NavigationController(rootViewController: settingsController)
    
    return [
        dashboardNavigation,
        libraryNavigation,
        inboxNavigation,
        settingsNavigation
    ]
}

func makeTabBarControllerDelegate() -> TabBarControllerDelegate
{
    TabBarControllerDelegate(shouldSelect: { _, _ in
        return true
    }, didSelect: { _, viewController in
        print("Selected tab: \(viewController)")
    })
}
