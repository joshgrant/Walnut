//
//  SystemDetailTableViewManager.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class SystemDetailTableViewManager: NSObject
{
    // MARK: - Variables
    
    var system: System
    var headerViews: [TableHeaderView] = []
    var cellModels: [[TableViewCellModel]] = []
    
    var tableView: UITableView
    
    weak var navigationController: NavigationController?
    weak var delegate: UITextFieldDelegate?
    
    // MARK: - Initialization
    
    init(
        system: System,
        delegate: UITextFieldDelegate,
        navigationController: NavigationController?)
    {
        self.system = system
        self.delegate = delegate
        self.navigationController = navigationController
        
        tableView = UITableView(frame: .zero, style: .grouped)
        
        super.init()
        
        makeCellModelTypes().forEach
        {
            tableView.register($0.cellClass, forCellReuseIdentifier: $0.cellReuseIdentifier)
        }
        
        self.headerViews = makeHeaderViews()
        self.cellModels = makeCellModels()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Functions
    
    func makeTextCellFirstResponderIfEmpty()
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        guard let textCell = cell as? TextEditCell else { return }
        
        if let text = textCell.textField.text
        {
            if text.count > 0 { return }
        }
        
        textCell.textField.becomeFirstResponder()
    }
    
    func makeCellModels() -> [[TableViewCellModel]]
    {
        [
            makeInfoSection(),
            makeStocksModels(),
            makeFlowsModels(),
            makeEventsModels(),
            makeNotesModels()
        ]
    }
    
    // MARK: - Factory
    
    func makeCellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            TextEditCellModel.self,
            TextCellModel.self,
            IdealInfoCellModel.self,
            SuggestedFlowCellModel.self,
            DetailCellModel.self
            // Title cell
            // Ideal cell
            // Suggested flows
            // Stock cell
            // Flow (detail bottom + right)
            // event cell (detail)
            // System cell (detail)
            // Note cell (detail)
        ]
    }
    
    func makeHeaderViewModels() -> [TableHeaderViewModel]
    {
        guard let navigationController = navigationController else
        {
            return []
        }
        
        return [
            InfoHeaderViewModel(),
            StocksHeaderViewModel(
                system: system,
                navigationController: navigationController),
            SystemDetailFlowsHeaderViewModel(),
            EventsHeaderViewModel(),
            SubSystemsHeaderViewModel(),
            NotesHeaderViewModel()
        ]
    }
    
    func makeHeaderViews() -> [TableHeaderView]
    {
        let models = makeHeaderViewModels()
        return models.map { TableHeaderView(model: $0) }
    }
}

extension SystemDetailTableViewManager: UITableViewDelegate
{
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView?
    {
        headerViews[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        headerViews.count.map { CGFloat(44) }[section]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        headerViews.count.map { CGFloat(44) }[section]
    }
}

extension SystemDetailTableViewManager: UITableViewDataSource
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

// MARK: - Sections

extension SystemDetailTableViewManager
{
    func makeInfoSection() -> [TableViewCellModel]
    {
        var section: [TableViewCellModel] = []
        
        section.append(TextEditCellModel(
                        text: system.title,
                        placeholder: "Name",
                        delegate: delegate))
        
        section.append(IdealInfoCellModel(
                        percentage: system.percentIdeal,
                        infoAction: nil))
        
        //        if let flow = system.suggestedFlow
        //        {
        //            section.append(SuggestedFlowCellModel(title: flow.title))
        //        }
        
        return section
    }
    
    func makeStocksModels() -> [TableViewCellModel]
    {
        let stocks = system.unwrappedStocks
        return stocks.map
        {
            DetailCellModel(title: $0.title, detail: $0.currentDescription)
        }
    }
    
    func makeFlowsModels() -> [TableViewCellModel]
    {
        let flows = system.unwrappedFlows
        return flows.map
        {
            DetailCellModel(title: $0.title, detail: "None")
        }
    }
    
    func makeEventsModels() -> [TableViewCellModel]
    {
        let events = system.unwrappedEvents
        return events.map
        {
            DetailCellModel(title: $0.title, detail: "None")
        }
    }
    
    func makeNotesModels() -> [TableViewCellModel]
    {
        let notes = system.unwrappedNotes
        return notes.map
        {
            DetailCellModel(title: $0.title, detail: $0.firstLine ?? "None")
        }
    }
}