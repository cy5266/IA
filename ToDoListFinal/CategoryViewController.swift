//
//  CategoryViewController.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 15/11/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet var folderView: UITableView!
    
    var allFolders = [folderCell]()
    var elementIndexForFolder: Int = 0
    var foldersFirebaseRef: CollectionReference!

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       // return allFolders.count
        return allFolders.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as! folderCell
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = allFolders[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         //performSegue(withIdentifier: "folderMainLink", sender: Any?.self)
        //self.performSegue(withIdentifier: "folderMainLink", sender: Any?.self)
     
        
        elementIndexForFolder = indexPath.row
        
           performSegue(withIdentifier: "folderMainLink", sender: Any?.self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let elementIndex = indexPath.row
               
               if editingStyle == UITableViewCell.EditingStyle.delete //https://www.youtube.com/watch?v=h7kasGi_1Tk
               {
                let userInput: [String: Int] = ["updateRemove" : elementIndex]
                      //  folderReference.addDocument(data: ["title": FinalFolderName])
               
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateRemoveElements"), object: nil, userInfo: userInput)
                
                print(elementIndex)
                let ViewContollerB = ViewController()
                ViewContollerB.trialForFolder(element: elementIndex)
                //ViewContollerB.shouldDeleteFolder()
                
               let docIDforFolder = allFolders[elementIndex].documentID
               allFolders.remove(at: elementIndex)
               foldersFirebaseRef.document(docIDforFolder).delete()
               viewDidLoad()

               }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
       {
           if segue.identifier == "folderMainLink"
           {
            if let ViewControllerRef = segue.destination as? ViewController
               {                
                    ViewControllerRef.folderIndex = elementIndexForFolder
               }
           }
        
        if segue.identifier == "folderLink"
           {
            if let AddFolderViewControllerRef = segue.destination as? AddFolderViewController
               {
                AddFolderViewControllerRef.folderRow = elementIndexForFolder
               }
           }

       }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFolders(_:)), name: NSNotification.Name("updateFolderName"), object: nil)
        
        foldersFirebaseRef = Firestore.firestore().collection("folders")
        trial()
        
        // Do any additional setup after loading the view.
    }
    
    func trial()
    {
        foldersFirebaseRef.getDocuments()
            {
            (docsSnapshot, err) in
            if let err = err
            {
                print("error \(err)")
            }
            else
            {
                self.allFolders.removeAll()
                for document in docsSnapshot!.documents
                {
                    
                    let newFolderCell = folderCell() //access folderCell class
                    newFolderCell.name = document["title"] as! String
                    newFolderCell.documentID = document.documentID
                    /*https://stackoverflow.com/questions/47743458/swift-firestore-get-document-id*/
                    
                    self.allFolders.append(newFolderCell)

                    /*https://stackoverflow.com/questions/47743458/swift-firestore-get-document-id*/
                    
                    self.folderView.reloadData()
                }
                
            }
            
            DispatchQueue.main.async
                {
                    self.folderView.reloadData()
            }
        }
        // trialReload()
        //self.tableView.reloadData()
    }
    
   @objc func reloadFolders(_ notification: NSNotification)
   {
       if let info = notification.userInfo as NSDictionary? //sets a variable as the information from the dictionary recieved from the Notification
        {
            if let stringFromUser = info["folderName"] as? String //sets a variable as the information from the key 'task'
            {
                trial()
                self.folderView.reloadData()
        }
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
}
