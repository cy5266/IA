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
    struct Objects //https://www.youtube.com/watch?v=zFMSovtqqUc
    {
        var sectionName: String //names for the section headings in the tableview e.g. High Priority
        var sectionContents: [TaskCell]! //content in the cell (the tasks)
    }
 
   // var highPriorityTasks: Array<TaskCell> = []
    var highPriorityTasks = [TaskCell]()
    var mediumPriorityTasks: Array<TaskCell> = []
    var lowPriorityTasks: Array<TaskCell> = []
    
    var allTasks = [Objects]()
    
    var shouldSegue: Bool = false
    var shouldDelete: Bool = false
    
    var elementIndex: Int = 0  //element user clicks on within a section
    var sectionIndex: Int = 0  //section user clicks on
    
    var tempElement: Int = 0
    
    var folderIndex: Int = 0 //folder index the user clicks on in the categoryivew
    
    var docID: String = ""  //docID from firebase for highpriority tasks
    var docIDforMedium: String = "" //docID from firebase for medium priority tasks
    var docIDforLow: String = ""
    
    var clickEditButton = 0
    
    var message: Int = 0
    
    var highPriorityFirebaseRef: CollectionReference!  //high priority firebase collection reference
    var mediumPriorityFirebaseRef: CollectionReference!   //medium priority firebase collection reference
    var lowPriorityFirebaseRef: CollectionReference! //low priority firebase collection reference
    
  //  var isEditing: Bool {setEditing(true, animated: false)}
    
    var notes: String = ""  //notes for the tasks
    
    @IBOutlet weak var tableView: UITableView! //https://stackoverflow.com/questions/33724190/ambiguous-reference-to-member-tableview
    
    @IBOutlet var deleteTask: UIBarButtonItem!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int //creates number of rows in each section
    {
        return allTasks[section].sectionContents.count  //makes the number of rows the amount of content within each priority section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  //detects the cells at a certain row
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.labelOutlet.text = allTasks[indexPath.section].sectionContents[indexPath.row].name  //makes the cell text the task
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        sectionIndex = indexPath.section
         elementIndex = indexPath.row
        
        if editingStyle == UITableViewCell.EditingStyle.delete //https://www.youtube.com/watch?v=h7kasGi_1Tk
        {
            if (sectionIndex == 0) //delete high priority tasks
            {
                docID = highPriorityTasks[elementIndex].documentID
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
//        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark
//        { //https://www.youtube.com/watch?v=5MZ-WJuSdpg
//
//
//
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
//
//        }
//        else
//        {
//            if (clickEditButton % 2 == 0)
//            {
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//            }
//        }
//        tableView.deselectRow(at: indexPath, animated: true) //https://stackoverflow*.com/questions/33046573/why-do-my-uitableviewcells-turn-grey-when-i-tap-on-them/33046735
 
    
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
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            allTasks.remove(at: indexPath.row)
            tableView.delete([indexPath])
            loadTask()
            self.tableView.reloadData()
        }
    }
 */
  
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
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false
        
        let btn: UIButton = UIButton()
        btn.backgroundColor = UIColor.white
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal) //https://stackoverflow.com/questions/2474289/how-can-i-change-uibutton-title-color
        btn.titleLabel?.font =  UIFont.systemFont(ofSize: 35)
        btn.addTarget(self, action: #selector(performAddTaskSegue), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = menuBarItem
       
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
//       var items = [UIBarButtonItem]()
//        let doneButton = UIButton()
//        doneButton.setTitle("Done", for: .normal)
//        doneButton.backgroundColor = UIColor.black
//
//        btn.setTitleColor(UIColor.black, for: .normal)
//        doneButton.addTarget(self, action: #selector(folderDone), for: .touchUpInside)
//        let barButton = UIBarButtonItem(customView: doneButton)
//
//        items.append(barButton)
//        toolbarItems = items
//
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        highPriorityFirebaseRef = Firestore.firestore().collection("highPriorityTasks")
        mediumPriorityFirebaseRef = Firestore.firestore().collection("mediumPriorityTasks")
        lowPriorityFirebaseRef = Firestore.firestore().collection("lowPriorityTasks")
        trial()
        trialMedium()
        trialForLow()
        
   
        NotificationCenter.default.addObserver(self, selector: #selector(reloadList(_:)), name: NSNotification.Name("updateTableHighPriority"), object: nil) //creates the notification center named 'updateTable' and calls the function reloadList when it recieves the data
    
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListforMedium(_:)), name: NSNotification.Name("updateTableMediumPriority"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListforLow(_:)), name: NSNotification.Name("updateTableLowPriority"), object: nil)
        
        self.tableView.reloadData()
        loadTask()

    }

    func trialForFolder(element: Int) -> Int
    {
        tempElement = element
        return(tempElement)
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
    
    func trial()
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
                self.highPriorityTasks.removeAll()
                for document in docsSnapshot!.documents
                {
            
                    
                    let newTask = TaskCell() //access TaskCell class
                    newTask.name = document["name"] as! String
                    /*https://stackoverflow.com/questions/47743458/swift-firestore-get-document-id*/
                    newTask.documentID = document.documentID
                   
                    let tempFolderIndex = document["index"] as! Int //bascially seeing which folder the user chose to add tasks into
                    
                    if(tempFolderIndex == self.folderIndex) //if the folder the task is from equals to the folder the user clicked
                    {
                    self.highPriorityTasks.append(newTask)
                   
                    }

//                    if ((document["index"] as! Int == tempFolderIndex) && self.shouldDelete)
//                    {
//                        self.highPriorityFirebaseRef.document(document.documentID).delete()
//                        self.shouldDelete = false
//                    }

                    self.loadTask()
                    self.tableView.reloadData()
                }
                
            }
            
            DispatchQueue.main.async
                {
            self.tableView.reloadData()
            }
        }
    

        // trialReload()
        //self.tableView.reloadData()
    }
 
    
    @objc func reloadList(_ notification: NSNotification) //load data here
    {
        /*
        if let info = notification.userInfo as NSDictionary? //sets a variable as the information from the dictionary recieved from the Notification
        {
            if let stringFromUser = info["task"] as? String //sets a variable as the information from the key 'task'
            {
                highPriorityTasks.append(stringFromUser) //adds the string from user into the array
            }
        }
        */
        
        trial()

    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      
    
    let trial = segue.destination as! NotesViewController //sets the destination as View Controller
    
   // something.taskName = self.task //passes the variable to the variable in View Controller
        trial.indexReference = tableView as! Int
    }
    
    */
    
    @objc func reloadListforMedium(_ notification: NSNotification)
    {
        trialMedium()
    }
    
    func trialMedium()
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
                    /*https://stackoverflow.com/questions/47743458/swift-firestore-get-document-id*/
                    newTask.documentID = document.documentID
                  //  newTask.update()
                    
                    let tempFolderIndex = document["index"] as! Int //bascially seeing which folder the user chose to add tasks into
                    
                    
                    if(tempFolderIndex == self.folderIndex) //if the folder the task is from equals to the folder the user clicked
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
        trialForLow()
    }
    
    func trialForLow()
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
                  //  newTask.update()
                    
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
    
    func loadTask()
    {
        allTasks = [Objects(sectionName: "High Priority", sectionContents: highPriorityTasks), Objects(sectionName: "Medium Priority", sectionContents: mediumPriorityTasks), Objects(sectionName: "Low Priority", sectionContents: lowPriorityTasks)]
    }
    
    
}

