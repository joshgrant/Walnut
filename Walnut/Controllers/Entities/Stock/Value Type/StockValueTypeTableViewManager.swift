//
//  StockValueTypeTableViewManager.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class StockValueTypeTableViewManager: NSObject
{
    // MARK: - Variables
    
    var stock: Stock
    
    var headerModels: [TableHeaderViewModel]
    var cellModels: [[TableViewCellModel]]
    
    var tableView: UITableView
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        self.tableView = UITableView(
            frame: .zero,
            style: .grouped)
        
        self.cellModels = Self.makeCellModels(stock: stock)
        self.headerModels = Self.makeHeaderModels()
        
        super.init()
        
        Self.cellModelTypes().forEach
        {
            tableView.register(
                $0.cellClass,
                forCellReuseIdentifier: $0.cellReuseIdentifier)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Functions
    
    static func cellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            CheckmarkCellModel.self
        ]
    }
    
    static func makeHeaderModels() -> [TableHeaderViewModel]
    {
        [
            TableHeaderViewModel(
                title: "Value Type".localized),
            TableHeaderViewModel(
                title: "Transition Type".localized)
        ]
    }
    
    static func makeCellModels(stock: Stock) -> [[TableViewCellModel]]
    {
        [
            [
                CheckmarkCellModel(
                    selectionIdentifier: .valueType(type: .boolean),
                    title: ValueType.boolean.title,
                    checked: stock.amountType == .boolean),
                CheckmarkCellModel(
                    selectionIdentifier: .valueType(type: .integer),
                    title: ValueType.integer.title,
                    checked: stock.amountType == .integer),
                CheckmarkCellModel(
                    selectionIdentifier: .valueType(type: .decimal),
                    title: ValueType.decimal.title,
                    checked: stock.amountType == .decimal)
            ],
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
        ]
    }
}

extension StockValueTypeTableViewManager: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let model = headerModels[section]
        return TableHeaderView(model: model)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Set the values on the stock
        // Reload the table view?
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let oldAmountPath = path(for: stock.amountType)
        let oldTransitionPath = path(for: stock.stateMachine)
        
        switch (indexPath.section, indexPath.row)
        {
        case (0, 0):
            stock.amountType = .boolean
        case (0, 1):
            stock.amountType = .integer
        case (0, 2):
            stock.amountType =  .decimal
        case (1, 0):
            stock.stateMachine = false
        case (1, 1):
            stock.stateMachine = true
        default:
            break
        }
        
        let newAmountPath = path(for: stock.amountType)
        let newTransitionPath = path(for: stock.stateMachine)
        
        cellModels = Self.makeCellModels(stock: stock)

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
        let model = cellModels[indexPath.section][indexPath.row]
        let message = TableViewSelectionMessage(tableView: tableView, cellModel: model)
        
        AppDelegate.shared.mainStream.send(message: message)
    }
    
    func path(for amountType: AmountType) -> IndexPath
    {
        switch amountType
        {
        case .boolean:
            return IndexPath(row: 0, section: 0)
        case .integer:
            return IndexPath(row: 1, section: 0)
        case .decimal:
            return IndexPath(row: 2, section: 0)
        }
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
}

extension StockValueTypeTableViewManager: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        cellModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        cellModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = cellModels[indexPath.section][indexPath.row]
        return model.makeCell(in: tableView, at: indexPath)
    }
}
