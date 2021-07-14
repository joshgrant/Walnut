//
//  NewStockModel.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation

class NewStockModel
{
    var title: String?
    var unit: Unit?
    var stockType = ValueType.boolean
    var isStateMachine: Bool = false
    
    var valid: Bool
    {
        return title != nil
            && unit != nil
    }
}