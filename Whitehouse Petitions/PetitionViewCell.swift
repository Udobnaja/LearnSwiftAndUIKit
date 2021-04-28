//
//  PetitionCellTableViewCell.swift
//  Whitehouse Petitions
//
//  Created by Anna Udobnaja on 28.04.2021.
//

import UIKit

class PetitionViewCell: UITableViewCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
