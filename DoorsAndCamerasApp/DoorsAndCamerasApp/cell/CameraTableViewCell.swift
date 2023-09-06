//
//  CameraTableViewCell.swift
//  DoorsAndCamerasApp
//
//  Created by sose yeritsyan on 21.08.23.
//

import UIKit

class CameraTableViewCell: UITableViewCell {
    
    static let cellID =  "cameraCell"
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var snapshotImageView: UIImageView!
    @IBOutlet weak var recImageView: UIImageView!
    @IBOutlet weak var cameraNameLabel: UILabel!
    
    
    func configure(camera: Camera) {
        
        self.snapshotImageView.load(urlString: camera.snapshot)
        self.starImageView.isHidden = !camera.isFavorite
        self.recImageView.isHidden = !camera.isRecording
        self.cameraNameLabel.text = camera.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
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
