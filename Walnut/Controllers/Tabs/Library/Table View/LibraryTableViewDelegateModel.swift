//
//  LibraryTableViewDelegateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import ProgrammaticUI

class LibraryTableViewDelegateModel: TableViewDelegateModel
{
    convenience init()
    {
        let didSelect = Self.makeDidSelect()
        
        self.init(
            headerViews: nil,
            sectionHeaderHeights: nil,
            estimatedSectionHeaderHeights: nil,
            didSelect: didSelect)
    }
    
    // MARK: - Factory
    
    static func makeDidSelect() -> TableViewSelectionClosure
    {
        { selection in
            
            let entityType = EntityType.libraryVisible[selection.indexPath.row]
            
            // Now we need to get the list view controller for the entityType
            
            print("Selected: \(entityType)")
            
            selection.tableView.deselectRow(
                at: selection.indexPath,
                animated: true)
            
            return
            
        }
        //    return { selection in
        //
        //        let entityType = EntityType.libraryVisible[selection.indexPath.row]
        //
        //        let page = Page(kind: entityType, modifier: .list)
        //
        //        let detailViewController = makeListController(
        //            page: page,
        //            context: context)
        //
        //        self.navigationController?
        //            .pushViewController(detailViewController, animated: true)
        //
        //        selection.tableView.deselectRow(at: selection.indexPath, animated: true)
        //
        //        // TODO: Use a state change to the app state, rather than the above statements
        //        return
        //
        //    }
    }
}
