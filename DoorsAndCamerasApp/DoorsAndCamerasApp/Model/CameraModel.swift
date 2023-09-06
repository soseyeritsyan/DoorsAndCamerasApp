//
//  CameraModel.swift
//  DoorsAndCamerasApp
//
//  Created by sose yeritsyan on 22.08.23.
//

import Foundation

struct Camera: Codable {
    var name: String
    var snapshot: String
    var room: String?
    var id: Int
    var isFavorite: Bool
    var isRecording: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, snapshot, room, id
        case isFavorite = "favorites"
        case isRecording = "rec"
    }
}
struct CameraResponse: Codable {
    let success: Bool
    let data: CameraData
}

struct CameraData: Codable {
    let room: [String]
    let cameras: [Camera]
}

extension Camera {
    
    init(cameraObject: CameraObject) {
        self.id = cameraObject.id
        self.name = cameraObject.name
        self.room = cameraObject.room
        self.isFavorite = cameraObject.isFavorite
        self.isRecording = cameraObject.isRecording
        self.snapshot = cameraObject.snapshot
    }
}
