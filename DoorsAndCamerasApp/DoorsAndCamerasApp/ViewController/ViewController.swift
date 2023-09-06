//
//  ViewController.swift
//  DoorsAndCamerasApp
//
//  Created by sose yeritsyan on 21.08.23.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var doorsCamerasCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var sectionArray = Segments.allCases
    var doorArray: [Door]? = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var cameraArray: [Camera]? = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedSegment: Segments = .cameras
    
//    var dataBaseManager: DatabaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 300
        self.tableView.refreshControl = refreshControl

        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        self.doorsCamerasCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCameraData()
        self.fetchDoorData()
    }
    
    @objc func refreshData() {
        
        switch self.selectedSegment {
        case .cameras:
            self.fetchCameraData()
        case .doors:
            self.fetchDoorData()

        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func fetchCameraData() {
        // Check if cached data exists in the db
        let cachedCameraData = DatabaseManager.shared.getAllObjects(CameraObject.self)
        
        guard cachedCameraData.isEmpty else {
            // Fetch data from db
            DispatchQueue.main.async {
                self.cameraArray = cachedCameraData.map { Camera(cameraObject: $0) }
            }
            return
        }
        
        // Fetch data from API
        ApiDataManager.shared.fetchData(endpoint: .cameras, responseType: CameraResponse.self) { cameraResponse, error in
            guard let cameraResponse = cameraResponse else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.cameraArray = cameraResponse.data.cameras
                
                let cameraObjects = cameraResponse.data.cameras.map { camera in
                    return CameraObject( id: camera.id, name: camera.name, room: camera.room, isFavorite: camera.isFavorite, isResponding: camera.isRecording, snapshot: camera.snapshot ) }
                
                DatabaseManager.shared.saveObjects(cameraObjects)
            }
        }
    }
    
    
    func fetchDoorData() {
        // Check if cached data exists in the db
        let cachedDoorData = DatabaseManager.shared.getAllObjects(DoorObject.self)
        
        guard cachedDoorData.isEmpty else {
            // Fetch data from db
            DispatchQueue.main.async {
                self.doorArray = cachedDoorData.map { Door(doorObject: $0) }
            }
            return
        }
        
        // Fetch data from API
        ApiDataManager.shared.fetchData(endpoint: .doors, responseType: DoorResponse.self) { doorResponse, error in
            guard let doorResponse = doorResponse else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.doorArray = doorResponse.data
                let doorObjects = doorResponse.data.map { door in
                    return DoorObject(id: door.id, name: door.name, room: door.room, isFavorite: door.isFavorite, snapshot: door.snapshot)
                }
                
                DatabaseManager.shared.saveObjects(doorObjects)
                
            }
        }
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedSegment {
        case .cameras:
            return cameraArray?.count ?? 0
        case .doors:
            return doorArray?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        if self.selectedSegment == .cameras {
            
            guard let cameraArray = self.cameraArray else { return UITableViewCell()
            }
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: CameraTableViewCell.cellID, for: indexPath) as? CameraTableViewCell
            cell?.configure(camera: cameraArray[indexPath.section])
            
            return cell ?? UITableViewCell()
            
        } else if self.selectedSegment == .doors {
            
            guard let doorArray = self.doorArray else { return UITableViewCell() }
            
            if doorArray[indexPath.section].snapshot == nil {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: DoorTableViewCell.cellID, for: indexPath) as? DoorTableViewCell
                cell?.configure(door: doorArray[indexPath.section], isLocked: true)
                
                return cell ?? UITableViewCell()
                
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: DomophoneTableViewCell.cellID, for: indexPath) as? DomophoneTableViewCell
                cell?.configure(door: doorArray[indexPath.section], isLocked: true)
                return cell ?? UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            // add to favorites
        }

        favoriteAction.image = UIImage(named: "star")
        favoriteAction.backgroundColor = self.tableView.backgroundColor

        let editAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            
            let alert = UIAlertController(title: "Edit door name", message: "Input door name", preferredStyle: UIAlertController.Style.alert )

            let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
                let textField = alert.textFields![0] as UITextField
                if let changedName = textField.text {

                    // change in db
                    
                    DatabaseManager.shared.updateDoorName(primaryKey: self.doorArray?[indexPath.section].id, newName: changedName)
                    
                    DispatchQueue.main.async {
                        self.fetchDoorData()
                        self.tableView.reloadData()
                    }
                }
                complete(true)
            }

            alert.addTextField { (textField) in
                textField.placeholder = "Input changes"
            }
            
            alert.addAction(save)
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
                complete(true)

            }
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        editAction.image = UIImage(named: "edit")
        editAction.backgroundColor = self.tableView.backgroundColor
        
        if self.selectedSegment == .cameras {
            return UISwipeActionsConfiguration(actions: [favoriteAction])
        }

        return UISwipeActionsConfiguration(actions: [favoriteAction, editAction])
      }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = self.doorsCamerasCollectionView.dequeueReusableCell(withReuseIdentifier: SegmentCollectionViewCell.cellID, for: indexPath) as? SegmentCollectionViewCell {
            cell.configure(section: self.sectionArray[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SegmentCollectionViewCell {
            cell.cellSelected()
            self.selectedSegment = self.sectionArray[indexPath.row]
            self.tableView.reloadData()
        }
    }


    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SegmentCollectionViewCell {
            cell.cellDiselected()
        }
    }
    
}


extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
