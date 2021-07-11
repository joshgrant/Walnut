//
//  LibraryController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class LibraryController: ViewController, RouterDelegate
{
    // MARK: - Variables
    
    var tabBarItemTitle: String { "Library".localized }
    var tabBarImage: UIImage? { Icon.library.getImage() }
    var tabBarTag: Int { 1 }

    var router: LibraryTableViewRouter
    var tableViewManager: LibraryTableViewManager
    
    // MARK: - Initialization

    init(
        context: Context,
        navigationController: UINavigationController)
    {
        self.router = LibraryTableViewRouter(context: context)
        self.tableViewManager = LibraryTableViewManager(context: context)
        
        super.init()
        router.delegate = self
        
        tabBarItem = makeTabBarItem()
        title = tabBarItemTitle
        
        view.embed(tableViewManager.tableView)
    }
}

extension LibraryController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}
