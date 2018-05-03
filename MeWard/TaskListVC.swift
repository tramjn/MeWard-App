//
//  TaskListVC.swift
//  MeWard
//
//  Created by Tram Nguyen on 4/28/18.
//  Copyright © 2018 Tram Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class TaskListVC: UIViewController {

    @IBOutlet weak var taskListTableView: UITableView!
    
    var authUI: FUIAuth!
    
    var addTaskButtion: UIButton!
    var defaultsData = UserDefaults.standard

    var taskNameArray = [String]()
    var taskPointsArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        taskListTableView.delegate = self
        taskListTableView.dataSource = self

        configureAddButton()
        
        taskNameArray = defaultsData.stringArray(forKey: "taskNameArray") ?? [String]()
        taskPointsArray = defaultsData.stringArray(forKey: "taskPointsArray") ?? [String]()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func savesDefaultData() {
        defaultsData.set(taskNameArray, forKey: "taskNameArray")
        defaultsData.set(taskPointsArray, forKey: "taskPointsArray")
    }
    
    // the green plus button
    func configureAddButton() {
        let addTaskButton = UIButton(frame: CGRect(x: 300, y: 615, width: 70, height: 70))
        addTaskButton.tintColor = UIColor.white
        addTaskButton.setImage(UIImage(named: "plus-icon"), for: .normal)
        addTaskButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        self.view.addSubview(addTaskButton)
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            taskListTableView.isHidden = false
        }
    }
    
    
    
    // TODO: save data from name and points input
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem" {
            let destination = segue.destination as! TaskDetailVC
            let index = taskListTableView.indexPathForSelectedRow!.row
            destination.taskToDo = taskNameArray[index]
            destination.taskPoints = taskPointsArray[index]
        } else {
            if let selectedPath = taskListTableView.indexPathForSelectedRow {
                taskListTableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
    @IBAction func unwindFromTaskDetailVC(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! TaskDetailVC
        if let indexPath = taskListTableView.indexPathForSelectedRow {
            taskNameArray[indexPath.row] = sourceViewController.taskToDo!
            taskPointsArray[indexPath.row] = sourceViewController.taskPoints!
            taskListTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: taskNameArray.count, section: 0)
            taskNameArray.append(sourceViewController.taskToDo!)
            taskPointsArray.append(sourceViewController.taskPoints!)
            taskListTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        savesDefaultData()
    }
    
    // when green button pressed, present modally to add new task
    @objc func addNewTask() {
        print("**** Add new task to list of to-do")
        performSegue(withIdentifier: "segueAddTask", sender: self)
        
    }
    
    

}



extension TaskListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = taskListTableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        taskCell.textLabel?.text = taskNameArray[indexPath.row]
        taskCell.detailTextLabel?.text = taskPointsArray[indexPath.row]
        return taskCell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskNameArray.remove(at: indexPath.row)
            taskPointsArray.remove(at: indexPath.row)
            taskListTableView.deleteRows(at: [indexPath], with: .fade)
            savesDefaultData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = taskNameArray[sourceIndexPath.row]
        let noteToMove = taskPointsArray[sourceIndexPath.row]
        taskNameArray.remove(at: sourceIndexPath.row)
        taskPointsArray.remove(at: sourceIndexPath.row)
        taskNameArray.insert(itemToMove, at: destinationIndexPath.row)
        taskPointsArray.insert(noteToMove, at: destinationIndexPath.row)
        savesDefaultData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}


extension TaskListVC: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        taskListTableView.isHidden = false
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        return loginViewController
    }
    
    
}

