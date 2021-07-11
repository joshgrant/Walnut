//
//  TransferFlowDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation

class TransferFlowDetailRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        case stockFrom
        case stockTo
        case eventDetail(event: Event)
        case historyDetail(history: History)
    }
    
    // MARK: - Variables
    
    var id = UUID()
    
    var flow: TransferFlow
    
    weak var root: NavigationController?
    weak var context: Context?
    
    weak var _stream: Stream?
    var stream: Stream { return _stream ?? AppDelegate.shared.mainStream }
    
    var presentedDestination: Destination?
    
    // MARK: - Initialization
    
    init(flow: TransferFlow, root: NavigationController?, context: Context?, _stream: Stream? = nil)
    {
        self.flow = flow
        
        self.root = root
        self._stream = _stream
        self.context = context
        subscribe(to: stream)
    }
    
    // MARK: - Functions
    
    func route(to destination: Destination, completion: (() -> Void)?)
    {
        switch destination
        {
        case .stockTo:
            routeToStockTo()
        case .stockFrom:
            routeToStockFrom()
        case .eventDetail(let event):
            print("Route to event detail: \(event)")
        case .historyDetail(let history):
            print("Route to history: \(history)")
        }
    }
    
    private func routeToStockFrom()
    {
        let searchController = LinkSearchController(entity: flow, entityType: Stock.self, context: context, _stream: stream)
        let navigationController = NavigationController(rootViewController: searchController)
        presentedDestination = .stockFrom
        root?.present(
            navigationController,
            animated: true,
            completion: nil)
    }
    
    private func routeToStockTo()
    {
        let searchController = LinkSearchController(entity: flow, entityType: Stock.self, context: context, _stream: stream)
        let navigationController = NavigationController(rootViewController: searchController)
        presentedDestination = .stockTo
        root?.present(
            navigationController,
            animated: true,
            completion: nil)
    }
}

extension TransferFlowDetailRouter: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TableViewSelectionMessage:
            handleTableViewSelectionMessage(m)
        default:
            break
        }
    }
    
    private func handleTableViewSelectionMessage(_ message: TableViewSelectionMessage)
    {
        if message.token == .transferFlowDetail
        {
            switch message.indexPath.section
            {
            case TableViewSectionType.info:
                handleInfoSectionSelection(row: message.indexPath.row)
            case TableViewSectionType.events:
                handleEventSectionSelection(row: message.indexPath.row)
            case TableViewSectionType.history:
                handleHistorySectionSelection(row: message.indexPath.row)
            default:
                assertionFailure("Not a valid index path")
            }
        }
    }
    
    private func handleInfoSectionSelection(row: Int)
    {
        switch row
        {
        case TableViewRowType.from.rawValue:
            route(to: .stockFrom, completion: nil)
        case TableViewRowType.to.rawValue:
            route(to: .stockTo, completion: nil)
        case TableViewRowType.amount.rawValue:
            // TODO: Open amount picker
            break
        case TableViewRowType.duration.rawValue:
            // TODO: Open duration picker
            break
        default:
            break
        }
    }
    
    private func handleEventSectionSelection(row: Int)
    {
        
    }
    
    private func handleHistorySectionSelection(row: Int)
    {
        
    }
}
