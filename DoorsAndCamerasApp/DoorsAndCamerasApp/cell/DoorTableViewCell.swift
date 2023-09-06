//
//  DoorTableViewCell.swift
//  DoorsAndCamerasApp
//
//  Created by sose yeritsyan on 24.08.23.
//

import UIKit

class DoorTableViewCell: UITableViewCell {
    
    static let cellID = "doorCell"
    
    @IBOutlet weak var doorNameLabel: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    var isLocked: Bool = true
    
    func configure(door: Door, isLocked: Bool) {
        
        self.doorNameLabel.text = door.name
        self.isLocked = isLocked
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        // Add shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
    }
}
