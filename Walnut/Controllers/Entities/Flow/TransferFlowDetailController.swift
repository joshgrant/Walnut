//
//  TransferFlowDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation
import UIKit

class TransferFlowDetailController: UIViewController, RouterDelegate
{
    // MARK: - Variables
    
    var id = UUID()
    
    var flow: TransferFlow
    
    var router: TransferFlowDetailRouter
    var responder: TransferFlowDetailResponder
    
    weak var context: Context?
    
    var tableView: TransferFlowDetailTableView
    
    var pinButton: UIBarButtonItem
    var runButton: UIBarButtonItem
    
    static let stream: Stream = {
        let stream = Stream(identifier: .transferFlow)
        AppDelegate.shared.mainStream.add(substream: stream)
        return stream
    }()
    
    // MARK: - Initialization
    
    init(flow: TransferFlow, context: Context?)
    {
        let responder = TransferFlowDetailResponder(flow: flow)
        
        self.flow = flow
        
        self.router = TransferFlowDetailRouter(
            flow: flow,
            context: context,
            _stream: Self.stream)
        self.responder = responder
        self.tableView = TransferFlowDetailTableView(
            flow: flow,
            stream: Self.stream)
        
        self.pinButton = Self.makePinButton(flow: flow, responder: responder)
        self.runButton = Self.makeRunButton(responder: responder)
        
        self.context = context
        
        super.init(nibName: nil, bundle: nil)
        
        subscribe(to: Self.stream)
        router.delegate = self
        
        view.embed(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Factory
    
    static func makePinButton(flow: TransferFlow, responder: TransferFlowDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: flow.isPinned
                ? Icon.pinFill.getImage()
                : Icon.pin.getImage(),
            style: .plain,
            target: responder,
            action: #selector(responder.pinButtonDidTouchUpInside(_:)))
    }
    
    static func makeRunButton(responder: TransferFlowDetailResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            image: Icon.activateFlow.getImage(),
            style: .plain,
            target: responder,
            action: #selector(responder.runButtonDidTouchUpInside(_:)))
    }
}

extension TransferFlowDetailController: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TextEditCellMessage:
            handle(m)
        case let m as LinkSelectionMessage:
            handle(m)
        default:
            break
        }
    }
    
    private func handle(_ message: TextEditCellMessage)
    {
        if message.entity == flow
        {
            title = message.title
            flow.title = message.title
            flow.managedObjectContext?.quickSave()
        }
    }
    
    private func handle(_ message: LinkSelectionMessage)
    {
        let stock = message.entity as! Stock
        // FIXME: This crashes
        let destination = router.presentedDestination!
        
        switch destination
        {
        case .stockFrom:
            flow.from = stock
        case .stockTo:
            flow.to = stock
        default:
            break
        }
        
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}
