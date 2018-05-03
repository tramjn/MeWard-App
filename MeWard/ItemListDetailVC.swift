//
//  ItemListDetailVC.swift
//  MeWard
//
//  Created by Tram Nguyen on 4/28/18.
//  Copyright © 2018 Tram Nguyen. All rights reserved.
//

import UIKit

class ItemListDetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var itemSearchField: UITextField!
    
    @IBOutlet weak var goalPointsField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var imageToChoose: UIImageView!
    
    
    
    
    
    
    var itemUserSearch: String?
    var goalPoints: String?
    var itemQueryInput: String!
    var itemDetailArray = [ItemDetailQuery]()
    var itemDetailQuery: ItemDetailQuery?
    
    var itemImagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let itemUserSearch = itemUserSearch {
            itemSearchField.text = itemUserSearch
            self.navigationItem.title = "Edit Goal"
            
            
        } else {
            self.navigationItem.title = "New Goal"
        }
        if let goalPoints = goalPoints {
            goalPointsField.text = goalPoints
        }
        itemSearchField.becomeFirstResponder()
//        let newSearch = ItemDetailQuery(searchQuery: "")
//        itemDetailArray.append(newSearch)
        itemImagePicker.delegate = self
        

        

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageToChoose.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromSaveGoal" {
            itemUserSearch = itemSearchField.text
            goalPoints = goalPointsField.text
        }
    }
    
    
    @IBAction func itemNameInputChanged(_ sender: UITextField) {
        if itemSearchField.text!.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
        
        
    }
    
    
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            itemImagePicker.sourceType = .camera
            itemImagePicker.delegate = self
            present(itemImagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
    }
    
    
    
    @IBAction func chooseFromLibraryButton(_ sender: UIButton) {
        itemImagePicker.sourceType = .photoLibrary
        itemImagePicker.delegate = self
        
        present(itemImagePicker, animated: true, completion: nil)
    }
    

    


    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    

}



