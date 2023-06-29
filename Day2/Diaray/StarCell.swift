//
//  StarCell.swift
//  Diaray
//
//  Created by 신현호 on 2023/06/21.
//

import UIKit

class StarCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
      self.contentView.layer.cornerRadius = 3.0
      self.contentView.layer.borderWidth = 1.0
      self.contentView.layer.borderColor = UIColor.black.cgColor
    }
    
}
