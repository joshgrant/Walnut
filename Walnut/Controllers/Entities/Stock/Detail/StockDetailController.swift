//
//  StockDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/26/21.
//

import Foundation
import UIKit

class StockDetailController: UIViewController, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var stock: Stock
    var router: StockDetailRouter
    
    var tableView: StockDetailTableView
    
    var pinBarButtonItem: UIBarButtonItem
    
    // MARK: - Initialization
    
    init(stock: Stock)
    {
        self.stock = stock
        self.router = StockDetailRouter(stock: stock)
        self.tableView = StockDetailTableView(stock: stock)
        
        self.pinBarButtonItem = Self.makePinNavigationItem(stock: stock)
        
        super.init(nibName: nil, bundle: nil)
        router.delegate = self
        subscribe(to: AppDelegate.shared.mainStream)
        
        title = stock.title
        
        view.embed(tableView)
        
        navigationItem.setRightBarButtonItems([pinBarButtonItem], animated: false)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        unsubscribe(from: AppDelegate.shared.mainStream)
    }
    
    // MARK: - Functions
    
    static func makePinNavigationItem(stock: Stock) -> BarButtonItem
    {
        let icon: Icon = stock.isPinned ? .pinFill : .pin
        
        let actionClosure = ActionClosure { sender in
            stock.isPinned.toggle()
            let message = EntityPinnedMessage(
                isPinned: stock.isPinned,
                entity: stock)
            AppDelegate.shared.mainStream.send(message: message)
        }
        
        return BarButtonItem(
            image: icon.getImage(),
            style: .plain,
            actionClosure: actionClosure)
    }
}

extension StockDetailController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TextEditCellMessage:
            handle(m)
        case let m as EntityPinnedMessage:
            handle(m)
        case let m as TableViewSelectionMessage:
            handle(m)
        case let m as LinkSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TextEditCellMessage)
    {
        guard message.entity == stock else { return }
        
        switch message.selectionIdentifier
        {
        // TODO: Unwrap the type of ideal and current `.ideal(let type):` and use
        // it to do Double/Bool/Int
        case .ideal:
            guard let content = Double(message.title) else { fatalError() }
            stock.idealValue = content
            tableView.shouldReload = true
        case .current:
            guard let content = Double(message.title) else { fatalError() }
            stock.amountValue = content
            tableView.shouldReload = true
        case .title:
            title = message.title
            stock.title = message.title
        default:
            break
        }
        
        stock.managedObjectContext?.quickSave()
    }
    
    // TODO: The same as the system detail
    private func handle(_ message: EntityPinnedMessage)
    {
        guard message.entity == stock else { return }
        
        let pinned = message.isPinned
        let icon: Icon = pinned ? .pinFill : .pin
        
        pinBarButtonItem.image = icon.getImage()
        stock.isPinned = pinned
        stock.managedObjectContext?.quickSave()
    }
    
    private func handle(_ message: TableViewSelectionMessage)
    {
        switch message.cellModel.selectionIdentifier
        {
        case .ideal:
            router.route(to: .ideal, completion: nil)
        case .current:
            router.route(to: .current, completion: nil)
        case .valueType, .transitionType:
            tableView.shouldReload = true
        default:
            break
        }
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        guard message.origin == .stockDimension else { return }
        guard let dimension = message.entity as? Dimension else { return }
        
        stock.dimension = dimension
        dimension.addToDimensionOf(stock)
        stock.managedObjectContext?.quickSave()
        
        tableView.shouldReload = true
    }
}
