//
//  ViewController.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 20/7/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //creates an object with two variables: sectionName and sectionContents
    struct Objects //"Sections in Table View! (Swift in Xcode)." YouTube, 18 June 2015,www.youtube.com/watch?v=zFMSovtqqUc. Accessed 21 Feb. 2020.
    {
        var sectionName: String //names for the section headings in the tableview e.g. High Priority
        var sectionContents: [TaskCell]! //content in the cell (the tasks)
    }
 
    var highPriorityTasks = [TaskCell]() //creates an array of TaskCell objects
    var mediumPriorityTasks: Array<TaskCell> = [] //creates an array of TaskCell objects
    var lowPriorityTasks: Array<TaskCell> = [] //creates an array of TaskCell objects
    
    var allTasks = [Objects]() //creates an array of Objects that contain both sectionName and sectionContents
    
    var shouldSegue: Bool = false
    
    var elementIndex: Int = 0  //element user clicks on within a section
    var sectionIndex: Int = 0  //section user clicks on
    
    var folderIndex: Int = 0 //folder index the user clicks on in the categoryivew
    
    var docID: String = ""  //docID from firebase for highpriority tasks
    var docIDforMedium: String = "" //docID from firebase for medium priority tasks
    var docIDforLow: String = ""
    
    var highPriorityFirebaseRef: CollectionReference!  //high priority firebase collection reference
    var mediumPriorityFirebaseRef: CollectionReference!   //medium priority firebase collection reference
    var lowPriorityFirebaseRef: CollectionReference! //low priority firebase collection reference
    
    var notes: String = ""  //notes for the tasks
    
    @IBOutlet weak var tableView: UITableView! //https://stackoverflow.com/questions/33724190/ambiguous-reference-to-member-tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int //creates number of rows in each section
    {
        return allTasks[section].sectionContents.count  //makes the number of rows the amount of content within each priority section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  //detects the cells at a certain row
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell //lets the cell become the tableViewCell with identifier "taskCell"
        cell.labelOutlet.text = allTasks[indexPath.section].sectionContents[indexPath.row].name  //makes the cell text the associated with the correct section, and row of the element
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        sectionIndex = indexPath.section //finds the index of the section, e.g. whether it's the first section (0), second section (1), or third (2)
         elementIndex = indexPath.row
        
        if editingStyle == UITableViewCell.EditingStyle.delete //https://www.youtube.com/watch?v=h7kasGi_1Tk
        {
            if (sectionIndex == 0) //delete high priority tasks
            {
                docID = highPriorityTasks[elementIndex].documentID //sets the docID variable as the document ID of the element in highPriorityTasks
                highPriorityTasks.remove(at: elementIndex)
                print(highPriorityTasks)
                highPriorityFirebaseRef.document(docID).delete() //https://stackoverflow.com/questions/57943765/swift-firestore-delete-document
                viewDidLoad()
            }
            else if (sectionIndex == 1)
            {
                docIDforMedium = mediumPriorityTasks[elementIndex].documentID
                mediumPriorityTasks.remove(at: elementIndex)
                mediumPriorityFirebaseRef.document(docIDforMedium).delete()
                viewDidLoad()
            }
            else if (sectionIndex == 2)
            {
                docIDforLow = lowPriorityTasks[elementIndex].documentID
                lowPriorityTasks.remove(at: elementIndex)
                lowPriorityFirebaseRef.document(docIDforLow).delete()
                viewDidLoad()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        shouldSegue = true
        elementIndex = indexPath.row
        sectionIndex = indexPath.section

        if (sectionIndex == 0)
        {
            docID = highPriorityTasks[elementIndex].documentID //using the element, find the TaskCell from array and access the field
        }
        else if (sectionIndex == 1)
        {
            docIDforMedium = mediumPriorityTasks[elementIndex].documentID
        }
        else if (sectionIndex == 2)
        {
            docIDforLow = lowPriorityTasks[elementIndex].documentID
        }
        
        performSegue(withIdentifier: "notesLink", sender: Any?.self)
        
        shouldSegue = false
    
    }
    
    @objc func performAddTaskSegue()
    {
        self.performSegue(withIdentifier: "addTaskLink", sender: self)
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        return shouldSegue
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return allTasks.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return allTasks[section].sectionName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "notesLink"
        {
            if let notesViewControllerRef = segue.destination as? NotesViewController
            {
                notesViewControllerRef.indexReference = docID //sets the indexreference variable in notesviewcontroller as the element the user clicks
                notesViewControllerRef.indexReferenceMedium = docIDforMedium
                notesViewControllerRef.indexReferenceLow = docIDforLow
                
                notesViewControllerRef.sectionIndex = sectionIndex
                notesViewControllerRef.elementInHighPriority = elementIndex
                notesViewControllerRef.elementInMediumPriority = elementIndex
                notesViewControllerRef.elementInLowPriority = elementIndex
            }
        }
        if segue.identifier == "addTaskLink"
        {
            if let AddTaskContollerRef = segue.destination as? AddTaskController
            {
                AddTaskContollerRef.folderIndex = folderIndex
        }
        }

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
 
    //
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false //makes sure the navigationController is visible upon launch
        
        highPriorityFirebaseRef = Firestore.firestore().collection("highPriorityTasks") //sets the collection reference varaible highPriorityFirebaseRef with the collection named "highPriorityTasks" in Firebase
        mediumPriorityFirebaseRef = Firestore.firestore().collection("mediumPriorityTasks") //sets the collection reference varaible mediumPriorityFirebaseRef with the collection named "mediumPriorityTasks" in Firebase
        lowPriorityFirebaseRef = Firestore.firestore().collection("lowPriorityTasks")
            //sets the collection reference varaible lowPriorityFirebaseRef with the collection named "lowPriorityTasks" in Firebase
        
        getDocumentsHigh() //calls the method that retrieves data from the "highPriorityTasks" collection in Firebase
        getDocumentsMedium() //calls the method that retrieves data from the "mediumPriorityTasks" collection in Firebase
        getDocumentsLow() //calls the method that retrieves data from the "lowPriorityTasks" collection in Firebase
        

         let btn: UIButton = UIButton()
         btn.backgroundColor = UIColor.white
         btn.setTitle("+", for: .normal)
         btn.setTitleColor(UIColor.black, for: .normal) //https://stackoverflow.com/questions/2474289/how-can-i-change-uibutton-title-color
         btn.titleLabel?.font =  UIFont.systemFont(ofSize: 35)
         btn.addTarget(self, action: #selector(performAddTaskSegue), for: .touchUpInside)
         
         let menuBarItem = UIBarButtonItem(customView: btn)
         self.navigationItem.rightBarButtonItem = menuBarItem
        
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         
         navigationController?.setNavigationBarHidden(false, animated: true)
        
   
        NotificationCenter.default.addObserver(self, selector: #selector(reloadList(_:)), name: NSNotification.Name("updateTableHighPriority"), object: nil) //creates the notification center named 'updateTable' and calls the function reloadList when it recieves the data
    
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListforMedium(_:)), name: NSNotification.Name("updateTableMediumPriority"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListforLow(_:)), name: NSNotification.Name("updateTableLowPriority"), object: nil)
        
        self.tableView.reloadData()
        loadTask()

    }
    
    func removeElementHigh(remove: String)
    {
        var counter = 0
        for elements in highPriorityTasks
        {
            
            if (elements.name == remove)
            {
        highPriorityTasks.remove(at: counter)
            }
            counter =  counter + 1
        }
    }
    
    func removeElementMed(remove: String)
       {
           var counter = 0
           for elements in mediumPriorityTasks
           {
               
               if (elements.name == remove)
               {
           mediumPriorityTasks.remove(at: counter)
               }
               counter =  counter + 1
           }
       }
    
    func removeElementLow(remove: String)
          {
              var counter = 0
              for elements in lowPriorityTasks
              {
                  
                  if (elements.name == remove)
                  {
              lowPriorityTasks.remove(at: counter)
                  }
                  counter =  counter + 1
              }
          }
    
    override func viewWillAppear(_ animated:Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func getDocumentsHigh()
    {
        highPriorityFirebaseRef.getDocuments() //"Get Data with Cloud Firestore." Firebase, firebase.google.com/docs/firestore/query-data/get-data. Accessed 20 Feb. 2020.
            {
            (docsSnapshot, err) in
            if let err = err
            {
                print("error \(err)") //print out the error recieved
            }
            else
            {
                self.highPriorityTasks.removeAll()  //removes all of the elements currently in the higPriorityTasks array to make sure information will not be duplicated
                for document in docsSnapshot!.documents //loops through all of the documents inside the collection highPrirorityTasks in Firebase
                {
                    let newTask = TaskCell() //access TaskCell class
                    newTask.name = document["name"] as! String //sets the name of the taskCell as the String value of the field "name" in the document
                    
                    newTask.documentID = document.documentID //sets the int value representing the documentID as the document's ID //https://stackoverflow.com/questions/47743458/swift-firestore-get-document-id
                   
                    let tempFolderIndex = document["index"] as! Int //sets a temporary variable as the value of integer value of the field "index" in the document to see which the user chose to add task into
                    
                    if(tempFolderIndex == self.folderIndex) //if the folder the task is from the folder the user clicked into
                    {
                    self.highPriorityTasks.append(newTask) //add the task into the Array
                    }
                    self.loadTask() //reload all of the tasks available to the user
                    self.tableView.reloadData() //reload the tableView to display the new data
                }
                
            }
            
            DispatchQueue.main.async
                {
            self.tableView.reloadData()
            }
        }
    }
 
    
    @objc func reloadList(_ notification: NSNotification) //load data here
    {
        getDocumentsHigh()
    }

    @objc func reloadListforMedium(_ notification: NSNotification)
    {
        getDocumentsMedium()
    }
    
    func getDocumentsMedium()
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
                self.mediumPriorityTasks.removeAll()
                for document in docsSnapshot!.documents
                {
                    let newTask = TaskCell() //access TaskCell class
                    newTask.name = document["name"] as! String
                    newTask.documentID = document.documentID
                    let tempFolderIndex = document["index"] as! Int
                    if(tempFolderIndex == self.folderIndex)
                    {
                    self.mediumPriorityTasks.append(newTask)
                    }
                    self.loadTask()
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async
                {
            self.tableView.reloadData()
            }
        }
    }
    
    @objc func reloadListforLow(_ notification: NSNotification)
    {
        getDocumentsLow()
    }
    
    func getDocumentsLow()
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
                self.lowPriorityTasks.removeAll()
                for document in docsSnapshot!.documents
                {
                    
                    let newTask = TaskCell() //access TaskCell class
                    newTask.name = document["name"] as! String
                    /*https://stackoverflow.com/questions/47743458/swift-firestore-get-document-id*/
                    newTask.documentID = document.documentID
                    
                    let tempFolderIndex = document["index"] as! Int //bascially seeing which folder the user chose to add tasks into
                    if(tempFolderIndex == self.folderIndex) //if the folder the task is from equals to the folder the user clicked
                    {
                    self.lowPriorityTasks.append(newTask)
                    }
                    self.loadTask()
                    self.tableView.reloadData()
                }
                
            }
            
            DispatchQueue.main.async
                {
            self.tableView.reloadData()
            }
        }
        loadTask()
        self.tableView.reloadData() //redisplays everything in the array
    }
    
    func loadTask() //loads all of the information that needs to be displayed in the tableView
    {
        allTasks = [Objects(sectionName: "High Priority", sectionContents: highPriorityTasks), Objects(sectionName: "Medium Priority", sectionContents: mediumPriorityTasks), Objects(sectionName: "Low Priority", sectionContents: lowPriorityTasks)] //this array contains 3 elements, but within each element there is seperate object that contains a String and an array containing all of the elements within that section
    }
    
    
}

