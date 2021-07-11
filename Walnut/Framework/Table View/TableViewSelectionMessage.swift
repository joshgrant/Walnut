//
//  TableViewSelectionMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

class TableViewSelectionMessage: Message
{
    var tableView: UITableView
    var cellModel: TableViewCellModel
    
    init(tableView: UITableView, cellModel: TableViewCellModel)
    {
        self.tableView = tableView
        self.cellModel = cellModel
    }
}
