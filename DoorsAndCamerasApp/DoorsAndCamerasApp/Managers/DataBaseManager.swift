//
//  DataBaseManager.swift
//  DoorsAndCamerasApp
//
//  Created by sose yeritsyan on 28.08.23.
//

import Foundation
import RealmSwift

class DoorObject: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name = ""
    @Persisted var room: String?
    @Persisted var isFavorite = false
    @Persisted var snapshot: String?
    
    convenience init(id: Int, name: String, room: String?, isFavorite: Bool, snapshot: String?) {
        
        self.init()
        self.id = id
        self.name = name
        self.room = room
        self.isFavorite = isFavorite
        self.snapshot = snapshot
    }
    
}

class CameraObject: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name = ""
    @Persisted var room: String?
    @Persisted var isFavorite = false
    @Persisted var isRecording = false
    @Persisted var snapshot = ""
    

    convenience init(id: Int, name: String, room: String?, isFavorite: Bool, isResponding: Bool, snapshot: String) {
        
        self.init()
        self.id = id
        self.name = name
        self.room = room
        self.isFavorite = isFavorite
        self.isRecording = isRecording
        self.snapshot = snapshot
    }
}


class DatabaseManager {
    private let realm: Realm
    static let shared = DatabaseManager()


    init() {
        
        do {
            self.realm = try Realm()
        } catch {
            // Handle the error
            fatalError("Error initializing Realm: \(error.localizedDescription)")
        }
    }
    
    func saveObjects<T: Object>(_ objects: [T]) {
        
        do {
            try realm.write {
                realm.add(objects, update: .modified)
            }
        } catch {
            print("Error saving objects: \(error.localizedDescription)")
        }
        
    }

    func saveObject(_ object: Object) {
        
        do {
            try self.realm.write {
                self.realm.add(object, update: .modified)
            }
        } catch {
            // Handle the error
            print("Error saving object: \(error.localizedDescription)")
            
        }
    }

    func updateDoorName(primaryKey: Int?, newName: String) {
        
        guard let primaryKey = primaryKey else { return }
        let realm = try! Realm()
        if let objectToUpdate = realm.object(ofType: DoorObject.self, forPrimaryKey: primaryKey) {
            try! realm.write {
                objectToUpdate.name = newName
            }
        }
        
    }

    func getAllObjects<T: Object>(_ objectType: T.Type) -> Results<T> {
        
        return self.realm.objects(objectType)
    }

    func clearAllData() {
        
        do {
            try self.realm.write {
                self.realm.deleteAll()
            }
        } catch {
            // Handle the error
            print("Error deleting in Realm: \(error.localizedDescription)")

        }
    }
    
}
