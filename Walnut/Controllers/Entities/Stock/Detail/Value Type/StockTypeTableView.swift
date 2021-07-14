//
//  StockTypeTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

class StockTypeTableView: TableView
{
    // MARK: - Variables
    
    var stock: Stock
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        super.init()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Set the values on the stock
        // Reload the table view?
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let oldAmountPath = path(for: stock.valueType)
        let oldTransitionPath = path(for: stock.stateMachine)
        
        switch (indexPath.section, indexPath.row)
        {
        case (0, 0):
            stock.valueType = .boolean
        case (0, 1):
            stock.valueType = .integer
        case (0, 2):
            stock.valueType = .decimal
        case (0, 3):
            stock.valueType = .percent
        case (1, 0):
            stock.stateMachine = false
        case (1, 1):
            stock.stateMachine = true
        default:
            break
        }
        
        let newAmountPath = path(for: stock.valueType)
        let newTransitionPath = path(for: stock.stateMachine)
        
        model = makeModel()
        
        var pathsToReload: [IndexPath] = []
        
        if oldAmountPath.row != newAmountPath.row
        {
            pathsToReload.append(contentsOf: [oldAmountPath, newAmountPath])
        }
        
        if oldTransitionPath.row != newTransitionPath.row
        {
            pathsToReload.append(contentsOf: [oldTransitionPath, newTransitionPath])
        }
        
        tableView.reloadRows(at: pathsToReload, with: .automatic)
        
        // FIXME: Not sure if this should be before or after updating the cell models
        let model = model.models[indexPath.section][indexPath.row]
        let message = TableViewSelectionMessage(tableView: tableView, cellModel: model)
        
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func path(for amountType: ValueType) -> IndexPath
    {
        return IndexPath(row: Int(amountType.rawValue), section: 0)
    }
    
    func path(for stateMachine: Bool) -> IndexPath
    {
        switch stateMachine
        {
        case true:
            return IndexPath(row: 1, section: 1)
        case false:
            return IndexPath(row: 0, section: 1)
        }
    }
    
    // MARK: - Model
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeValueTypeSection(stock: stock),
            makeTransitionTypeSection(stock: stock)
        ])
    }
    
    // MARK: Value Type
    
    func makeValueTypeSection(stock: Stock) -> TableViewSection
    {
        
        TableViewSection(
            header: .valueType,
            models: makeValueTypeModels(stock: stock))
    }
    
    func makeValueTypeModels(stock: Stock) -> [TableViewCellModel]
    {
        return ValueType.allCases.map { type in
            CheckmarkCellModel(
                selectionIdentifier: .valueType(type: type),
                title: type.description,
                checked: stock.valueType == type)
        }
    }
    
    // MARK: Transition Type
    
    func makeTransitionTypeSection(stock: Stock) -> TableViewSection
    {
        TableViewSection(
            header: .transitionType,
            models: makeTransitionTypeModels(stock: stock))
    }
    
    func makeTransitionTypeModels(stock: Stock) -> [TableViewCellModel]
    {
        [
            CheckmarkCellModel(
                selectionIdentifier: .transitionType(type: .continuous),
                title: TransitionType.continuous.title,
                checked: !stock.stateMachine),
            CheckmarkCellModel(
                selectionIdentifier: .transitionType(type: .stateMachine),
                title: TransitionType.stateMachine.title,
                checked: stock.stateMachine)
        ]
    }
}