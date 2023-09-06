//
//  DomophoneTableViewCell.swift
//  DoorsAndCamerasApp
//
//  Created by sose yeritsyan on 26.08.23.
//

import UIKit

class DomophoneTableViewCell: UITableViewCell {
    
    static let cellID = "domophoneCell"
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var snapshotImageView: UIImageView!
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var doorNameLabel: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    
    var isLocked: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(door: Door, isLocked: Bool) {
        
        self.snapshotImageView.load(urlString: door.snapshot ?? "")
        self.doorNameLabel.text = door.name
        self.isLocked = isLocked
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
