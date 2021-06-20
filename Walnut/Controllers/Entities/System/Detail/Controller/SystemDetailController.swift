//
//  SystemDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit
import ProgrammaticUI

class SystemDetailController: ViewController<
                                SystemDetailControllerModel,
                                SystemDetailViewModel,
                                SystemDetailView>
{
    // MARK: - Initialization
    
    required init(
        controllerModel: SystemDetailControllerModel,
        viewModel: SystemDetailViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        title = model.title
    }
    
    convenience init(system: System, navigationController: NavigationController)
    {
        let controllerModel = SystemDetailControllerModel(system: system)
        let viewModel = SystemDetailViewModel(system: system, navigationController: navigationController)
        
        self.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        // Menu Bar
        
        let duplicateAction = Self.makeDuplicateAction()
        let pinAction = Self.makePinAction(system: system)
        
        actionClosures.insert(duplicateAction)
        actionClosures.insert(pinAction)
        
        let duplicateItem = Self.makeDuplicateNavigationItem(action: duplicateAction)
        let pinItem = Self.makePinNavigationItem(system: system, action: pinAction)
        
        navigationItem.setRightBarButtonItems([duplicateItem, pinItem], animated: false)
    }
    
    // MARK: - Factory
    
    static func makeDuplicateAction() -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on duplicate")
        }
    }
    
    static func makePinAction(system: System) -> ActionClosure
    {
        ActionClosure { sender in
            print("Tapped on pin")
            system.isPinned.toggle()
        }
    }
    
    static func makeDuplicateNavigationItem(action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.copy.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
    
    static func makePinNavigationItem(system: System, action: ActionClosure) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: system.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: action,
            action: #selector(action.perform(sender:)))
    }
}
