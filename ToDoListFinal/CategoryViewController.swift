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
    var highPriority = [String]()
    var medPriority = [String]()
    var lowPriority = [String]()
    var elementIndexForFolder: Int = 0
    var foldersFirebaseRef: CollectionReference!
    var highPriorityFirebaseRef: CollectionReference!
    var mediumPriorityFirebaseRef: CollectionReference!
    var lowPriorityFirebaseRef: CollectionReference!
    
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
               let docIDforFolder = allFolders[elementIndex].documentID
               allFolders.remove(at: elementIndex)
               foldersFirebaseRef.document(docIDforFolder).delete()
//                if(elementIndex == 0)
//                {
                    trialForHigh(element: elementIndex)
                //}
//                else if(elementIndex == 1)
//                {
                    trialForMedium(element: elementIndex)
//                }
//                else if (elementIndex == 2)
//                {
                    trialForLow(element: elementIndex)
//                }
               viewDidLoad()
                
              }
    }
    
    func trialForHigh(element: Int)
    {
        highPriorityFirebaseRef.getDocuments()
            {
            (docsSnapshot, err) in
            if let err = err
            {
                print("error \(err)")
            }
            else
            {
                self.highPriority.removeAll()
                for document in docsSnapshot!.documents
                {
                    if document["index"] as! Int == element
                    {
                        let temp = document.documentID
                        self.highPriorityFirebaseRef.document(temp).delete()
                       // self.highPriority.append(document["name"] as! String)
                        let removetThisElement = document["name"] as! String
                        let ViewContollerB = ViewController()
                        ViewContollerB.removeElementHigh(remove: removetThisElement)
                    }
                    else if document["index"] as! Int > element
                    {
                        let documentID = document.documentID
                        var tempValue = document["index"] as! Int
                        tempValue-=1

                        let everyDocument = self.highPriorityFirebaseRef.document(documentID)
                        everyDocument.updateData(["index": tempValue])
                    }
                }
            }
            DispatchQueue.main.async
                {
                    self.folderView.reloadData()
            }
        }
    }
    
    func trialForMedium(element: Int)
    {
        mediumPriorityFirebaseRef.getDocuments()
            {
            (docsSnapshot, err) in
            if let err = err
            {
                print("error \(err)")
            }
            else
            {
                self.medPriority.removeAll()
                for document in docsSnapshot!.documents
                {
                    if document["index"] as! Int == element
                    {
                        let temp = document.documentID
                        self.mediumPriorityFirebaseRef.document(temp).delete()
                        let removetThisElement = document["name"] as! String
                        let ViewContollerB = ViewController()
                        ViewContollerB.removeElementMed(remove: removetThisElement)
                    }
                    else if document["index"] as! Int > element
                    {
                        let documentID = document.documentID
                        var tempValue = document["index"] as! Int
                        tempValue-=1

                        let everyDocument = self.mediumPriorityFirebaseRef.document(documentID)
                        everyDocument.updateData(["index": tempValue])
                    }
                }
            }
            DispatchQueue.main.async
                {
                    self.folderView.reloadData()
            }
        }
    }
    
    func trialForLow(element: Int)
    {
        lowPriorityFirebaseRef.getDocuments()
            {
            (docsSnapshot, err) in
            if let err = err
            {
                print("error \(err)")
            }
            else
            {
                self.lowPriority.removeAll()
                for document in docsSnapshot!.documents
                {
                    if document["index"] as! Int == element
                    {
                        let temp = document.documentID
                        self.lowPriorityFirebaseRef.document(temp).delete()
                       // self.highPriority.append(document["name"] as! String)
                        let removetThisElement = document["name"] as! String
                        let ViewContollerB = ViewController()
                        ViewContollerB.removeElementLow(remove: removetThisElement)
                    }
                    else if document["index"] as! Int > element
                    {
                        let documentID = document.documentID
                        var tempValue = document["index"] as! Int
                        tempValue-=1

                        let everyDocument = self.lowPriorityFirebaseRef.document(documentID)
                        everyDocument.updateData(["index": tempValue])
                    }
                }
            }
            DispatchQueue.main.async
                {
                    self.folderView.reloadData()
            }
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
        highPriorityFirebaseRef = Firestore.firestore().collection("highPriorityTasks")
        mediumPriorityFirebaseRef = Firestore.firestore().collection("mediumPriorityTasks")
        lowPriorityFirebaseRef = Firestore.firestore().collection("lowPriorityTasks")
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
