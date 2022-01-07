//
//  PinnedItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

final class PinnedItem: Hashable, Identifiable
{
    // MARK: - Variables
    
    let id = UUID()
    
    let text: String
    let image: UIImage
    
    let entity: Pinnable
    
    // MARK: - Initialization
    
    init(text: String, image: UIImage, entity: Pinnable)
    {
        self.text = text
        self.image = image
        self.entity = entity
    }
    
    // MARK: - Equatable
    
    static func == (lhs: PinnedItem, rhs: PinnedItem) -> Bool
    {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}

extension PinnedItem: Registered
{
    static var registration: UICollectionView.CellRegistration<UICollectionViewListCell, PinnedItem> =
    {
        .init { cell, indexPath, item in
            var configuration = UIListContentConfiguration.cell()
            configuration.text = item.text
            cell.contentConfiguration = configuration
            cell.accessories = [
                item.makeImageAccessory(),
                .disclosureIndicator()
            ]
        }
    }()
    
    private func makeImageAccessory() -> UICellAccessory
    {
        let imageView = UIImageView(image: image)
        imageView.tintColor = .secondaryLabel // Change to tableViewIcon
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: imageView,
            placement: .trailing(displayed: .always, at: { _ in 0 }))
        return .customView(configuration: configuration)
    }
}