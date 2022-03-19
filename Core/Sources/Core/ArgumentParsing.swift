//
//  ArgumentParsing.swift
//
//  Created by Joshua Grant on 3/19/22.
//

import Foundation

public func parseType<T: LosslessStringConvertible>(from arguments: [String]) -> T?
{
    guard let first = arguments.first else
    {
        print("Couldn't parse \(T.self); `arguments` was empty.")
        return nil
    }
    
    return T(first)
}