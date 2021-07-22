//
//  TableHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

open class TableHeaderViewModel
{
    // MARK: - Variables
    
    public var title: String
    public var icon: Icon?
    
    public var disclosureTriangleActionClosure: ActionClosure?
    public var searchButtonActionClosure: ActionClosure?
    public var linkButtonActionClosure: ActionClosure?
    public var addButtonActionClosure: ActionClosure?
    public var editButtonActionClosure: ActionClosure?
    
    public var hasDisclosureTriangle: Bool { disclosureTriangleActionClosure != nil }
    public var hasSearchButton: Bool { searchButtonActionClosure != nil }
    public var hasLinkButton: Bool { linkButtonActionClosure != nil }
    public var hasAddButton: Bool { addButtonActionClosure != nil }
    public var hasEditButton: Bool { editButtonActionClosure != nil }
    
    public var editButtonTitle: String { "Edit".localized } // TODO: Move to constants
    
    // MARK: - Initialization
    
    public init(title: String)
    {
        self.title = title
    }
    
    public init(title: String, icon: Icon)
    {
        self.title = title
        self.icon = icon
    }
}

extension TableHeaderViewModel
{
    static let info = TableHeaderViewModel(title: "Info".localized)
    static let history = TableHeaderViewModel(title: "History".localized)
    static let pinned = TableHeaderViewModel(title: "Pinned".localized, icon: .pin)
    static let flows = TableHeaderViewModel(title: "Flows".localized, icon: .flow)
    static let forecast = TableHeaderViewModel(title: "Forecast".localized, icon: .forecast)
    static let priority = TableHeaderViewModel(title: "Priority".localized, icon: .priority)
    static let valueType = TableHeaderViewModel(title: "Value Type".localized)
    static let transitionType = TableHeaderViewModel(title: "Transition Type".localized)
    static let references = TableHeaderViewModel(title: "References".localized)
    static let links = TableHeaderViewModel(title: "Links".localized)
    static let ideal = TableHeaderViewModel(title: "Ideal".localized)
    static let current = TableHeaderViewModel(title: "Current".localized)
    static let stateMachine = TableHeaderViewModel(title: "States".localized)
    static let constraints = TableHeaderViewModel(title: "Constraints".localized)
    static let goal = TableHeaderViewModel(title: "Goal".localized)
    
    static let outflows = TableHeaderViewModel(title: "Outflows".localized)
    static let inflows = TableHeaderViewModel(title: "Inflows".localized)
    
    static let subsystems: TableHeaderViewModel = {
        let model = TableHeaderViewModel(title: "Subsystems".localized, icon: .system)
        model.disclosureTriangleActionClosure = ActionClosure(performClosure: { sender in print("DISCLOSE")})
        model.searchButtonActionClosure = ActionClosure(performClosure: { sender in print("SEARCH") })
        model.addButtonActionClosure = ActionClosure(performClosure: { sender in print("ADD") })
        return model
    }()
    
    static let systemDetailFlows: TableHeaderViewModel = {
        let model = TableHeaderViewModel(title: "Flows".localized, icon: .flow)
        model.disclosureTriangleActionClosure = ActionClosure(performClosure: { sender in print("DISCLOSE")})
        model.searchButtonActionClosure = ActionClosure(performClosure: { sender in print("SEARCH") })
        model.addButtonActionClosure = ActionClosure(performClosure: { sender in print("ADD") })
        return model
    }()
    
    static let states: TableHeaderViewModel = {
        let model = TableHeaderViewModel(title: "States".localized, icon: .state)
        model.disclosureTriangleActionClosure = ActionClosure(performClosure: { sender in print("DISCLOSE")})
        model.editButtonActionClosure = ActionClosure(performClosure: { sender in print("EDIT") })
        return model
    }()
    
    static let notes: TableHeaderViewModel = {
        let model = TableHeaderViewModel(title: "Notes".localized, icon: .note)
        model.disclosureTriangleActionClosure = ActionClosure(performClosure: { sender in print("DISCLOSE")})
        model.searchButtonActionClosure = ActionClosure(performClosure: { sender in print("SEARCH") })
        model.addButtonActionClosure = ActionClosure(performClosure: { sender in print("ADD") })
        return model
    }()
    
    static let events: TableHeaderViewModel = {
        let model = TableHeaderViewModel(title: "Events".localized, icon: .event)
        model.disclosureTriangleActionClosure = ActionClosure(performClosure: { sender in print("DISCLOSE")})
        model.searchButtonActionClosure = ActionClosure(performClosure: { sender in print("SEARCH") })
        model.addButtonActionClosure = ActionClosure(performClosure: { sender in print("ADD") })
        return model
    }()
}
