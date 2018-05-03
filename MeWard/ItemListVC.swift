//
//  ItemListVC.swift
//  MeWard
//
//  Created by Tram Nguyen on 4/28/18.
//  Copyright © 2018 Tram Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class ItemListVC: UIViewController {
    @IBOutlet weak var itemListTableView: UITableView!
    var addItemButtion: UIButton!
    
    var goalItemNameArray = [String]()
    var goalItemPointsArray = [String]()
    
    
    var defaultsData = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddButton()
        itemListTableView.dataSource = self
        itemListTableView.delegate = self
        
        goalItemNameArray = defaultsData.stringArray(forKey: "goalItemNameArray") ?? [String]()
        goalItemPointsArray = defaultsData.stringArray(forKey: "goalItemPointsArray") ?? [String]()
        
        
        

    }
    
    func savesDefaultData() {
        defaultsData.set(goalItemNameArray, forKey: "goalItemNameArray")
        defaultsData.set(goalItemPointsArray, forKey: "goalItemPointsArray")

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditGoalItem" {
            let destination = segue.destination as! ItemListDetailVC
            let index = itemListTableView.indexPathForSelectedRow!.row
            destination.itemUserSearch = goalItemNameArray[index]
            destination.goalPoints = goalItemPointsArray[index]

        } else {
            if let selectedPath = itemListTableView.indexPathForSelectedRow {
                itemListTableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
    @IBAction func unwindFromItemListDetailVC(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! ItemListDetailVC
        if let indexPath = itemListTableView.indexPathForSelectedRow {
            goalItemNameArray[indexPath.row] = sourceViewController.itemUserSearch!
            goalItemPointsArray[indexPath.row] = sourceViewController.goalPoints!
            itemListTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: goalItemNameArray.count, section: 0)
            goalItemNameArray.append(sourceViewController.itemUserSearch!)
            goalItemPointsArray.append(sourceViewController.goalPoints!)
            
            itemListTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        savesDefaultData()
    }
    
    func configureAddButton() {
        let addTaskButton = UIButton(frame: CGRect(x: 300, y: 615, width: 70, height: 70))
        addTaskButton.tintColor = UIColor.white
        addTaskButton.setImage(UIImage(named: "plus-icon"), for: .normal)
        addTaskButton.addTarget(self, action: #selector(addNewWishlistItem), for: UIControlEvents.touchUpInside)
        self.view.addSubview(addTaskButton)
    }
    
    
    
    @objc func addNewWishlistItem() {
        print("**** Add new task to list of to-do")
        performSegue(withIdentifier: "segueToItemDetailVC", sender: self)
        
    }

    
    
    @IBAction func backToTaskListButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        print("Please work")
    }
    
    
    
    
    

}

extension ItemListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalItemNameArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = itemListTableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        itemCell.textLabel?.text = goalItemNameArray[indexPath.row]
        itemCell.detailTextLabel?.text = goalItemPointsArray[indexPath.row]
        return itemCell

    }
    
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                goalItemNameArray.remove(at: indexPath.row)
                goalItemPointsArray.remove(at: indexPath.row)
                itemListTableView.deleteRows(at: [indexPath], with: .fade)
                savesDefaultData()
            }
            
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = goalItemNameArray[sourceIndexPath.row]
        let noteToMove = goalItemPointsArray[sourceIndexPath.row]
        goalItemNameArray.remove(at: sourceIndexPath.row)
        goalItemPointsArray.remove(at: sourceIndexPath.row)
        goalItemNameArray.insert(itemToMove, at: destinationIndexPath.row)
        goalItemPointsArray.insert(noteToMove, at: destinationIndexPath.row)
        savesDefaultData()


    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    

}
