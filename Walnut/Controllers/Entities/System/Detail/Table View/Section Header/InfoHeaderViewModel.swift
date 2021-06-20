//
//  InfoHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class InfoHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(title: "Info".localized)
    }
}
