//
//  EventFactory.swift
//  Walnut
//
//  Created by Joshua Grant on 1/9/22.
//

import Foundation
import Core

protocol EventFactory: Factory
{
    func makeController() -> EventDetailController
    func makeRouter() -> EventDetailRouter
}
