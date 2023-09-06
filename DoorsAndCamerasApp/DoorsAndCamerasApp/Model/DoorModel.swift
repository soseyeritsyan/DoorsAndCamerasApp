//
//  DoorModel.swift
//  DoorsAndCamerasApp
//
//  Created by sose yeritsyan on 23.08.23.
//

import Foundation

struct Door: Codable {
    var name: String
    var room: String?
    var id: Int
    var isFavorite: Bool
    var snapshot: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case name, room, id, snapshot
        case isFavorite = "favorites"
    }
    
}

struct DoorResponse: Codable {
    let success: Bool
    let data: [Door]
}

extension Door {
    init(doorObject: DoorObject) {
        
        self.id = doorObject.id
        self.name = doorObject.name
        self.room = doorObject.room
        self.isFavorite = doorObject.isFavorite
        self.snapshot = doorObject.snapshot
    }
}
