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
    
    // MARK: - Initialization
    
    init(
        system: System)
    {
        self.system = system
        
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
            InfoCellModel.self,
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
        return [
            TableHeaderViewModel.info,
            StocksHeaderViewModel(system: system),
            SystemDetailFlowsHeaderViewModel(),
            EventsHeaderViewModel(),
//            SubSystemsHeaderViewModel(),
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
        44
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let message = SystemDetailTableViewSelectedMessage(
            tableView: tableView,
            indexPath: indexPath)
        AppDelegate.shared.mainStream.send(message: message)
        tableView.deselectRow(at: indexPath, animated: true)
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
                        selectionIdentifier: .title,
                        text: system.title,
                        placeholder: "Name".localized,
                        entity: system))
        
        section.append(InfoCellModel(
                        selectionIdentifier: .ideal,
                        title: "Ideal".localized,
                        detail: "\(system.percentIdeal)%"))
        
        let suggestedFlows: [Flow] = system.unwrapped(\System.suggestedFlows)
        if let flow = suggestedFlows.first
        {
            section.append(SuggestedFlowCellModel(
                            selectionIdentifier: .flow(flow: flow),
                            title: flow.title))
        }
        
        return section
    }
    
    func makeStocksModels() -> [TableViewCellModel]
    {
        let stocks = system.unwrappedStocks
        return stocks.map
        {
            DetailCellModel(
                selectionIdentifier: .stock(stock: $0),
                title: $0.title,
                detail: $0.currentDescription,
                disclosure: true)
        }
    }
    
    func makeFlowsModels() -> [TableViewCellModel]
    {
        let flows = system.unwrappedFlows
        return flows.map
        {
            DetailCellModel(
                selectionIdentifier: .flow(flow: $0),
                title: $0.title,
                detail: "None",
                disclosure: true)
        }
    }
    
    func makeEventsModels() -> [TableViewCellModel]
    {
        let events = system.unwrappedEvents
        return events.map
        {
            DetailCellModel(
                selectionIdentifier: .event(event: $0),
                title: $0.title,
                detail: "None",
                disclosure: true)
        }
    }
    
    func makeNotesModels() -> [TableViewCellModel]
    {
        let notes = system.unwrappedNotes
        return notes.map
        {
            DetailCellModel(
                selectionIdentifier: .note(note: $0),
                title: $0.title,
                detail: $0.firstLine ?? "None",
                disclosure: true)
        }
    }
}
