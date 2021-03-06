//
//  AddTaskViewController.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 15/11/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore    

class AddFolderViewController: UIViewController
{

    @IBOutlet var folderName: UITextField!
    var folderRow: Int = 0
    
     var folderReference: CollectionReference!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        folderReference = Firestore.firestore().collection("folders")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addNewFolder(_ sender: Any)
    {
        if let FinalFolderName = folderName.text, !FinalFolderName.isEmpty
        {
            let userInput: [String: String] = ["folderName" : FinalFolderName]
             folderReference.addDocument(data: ["title": FinalFolderName])            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateFolderName"), object: nil, userInfo: userInput)
        }
        
        returnToFolderViewController()
        
    }
    
    func returnToFolderViewController()
       {
           navigationController?.popViewController(animated: true) //brings it back to the ViewController page
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
