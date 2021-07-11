//
//  TextEditCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

class TextEditCellModel: NSObject, TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    
    var text: String?
    var placeholder: String
    var entity: Entity
    weak var stream: Stream?
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        text: String?,
        placeholder: String,
        entity: Entity,
        stream: Stream? = nil)
    {
        self.selectionIdentifier = selectionIdentifier
        self.text = text
        self.placeholder = placeholder
        self.entity = entity
        self.stream = stream
    }
    
    static var cellClass: AnyClass { TextEditCell.self }
}

extension TextEditCellModel: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let title = textField.text ?? ""
        let message = TextEditCellMessage(title: title, entity: entity)
        
        if let stream = stream
        {
            stream.send(message: message)
        }
        else
        {
            AppDelegate.shared.mainStream.send(message: message)
        }
    }
}


class TextEditCell: TableViewCell<TextEditCellModel>
{
    // MARK: - Variables
    
    var textField: UITextField
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        textField = UITextField()
        
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier)
        
        let contentStackView = UIStackView(arrangedSubviews: [textField])
        contentStackView.set(height: 44)
        
        contentView.embed(
            contentStackView,
            padding: .init(
                top: 0,
                left: 16,
                bottom: 0,
                right: 5),
            bottomPriority: .defaultLow)
    }
    
    // MARK: - Configuration
    
    override func configure(with model: TextEditCellModel)
    {
        textField.placeholder = model.placeholder
        textField.text = model.text
        textField.delegate = model
    }
}
