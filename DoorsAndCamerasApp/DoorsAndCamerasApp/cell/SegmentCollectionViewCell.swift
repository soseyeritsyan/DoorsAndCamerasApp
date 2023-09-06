//
//  SegmentCollectionViewCell.swift
//  DoorsAndCamerasApp
//
//  Created by sose yeritsyan on 21.08.23.
//

import UIKit

enum Segments: String, CaseIterable {
    case cameras
    case doors
}

class SegmentCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "segmentCell"
    
    @IBOutlet weak var segmentLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    func configure(section: Segments) {
        
        var segment = ""
        switch section {
        case .cameras:
            segment = "Камеры"
        case .doors:
            segment = "Двери"

        }
        self.segmentLabel.text = segment
        
        if self.isSelected {
            self.selectedView.isHidden = false
        } else {
            self.selectedView.isHidden = true
        }

    }
    
    func cellSelected() {
        self.selectedView.isHidden = false
    }
    
    func cellDiselected() {
        self.selectedView.isHidden = true
    }
    
    
}
