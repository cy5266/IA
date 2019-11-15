//
//  ViewController.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 20/7/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    struct Objects //https://www.youtube.com/watch?v=zFMSovtqqUc
    {
        var sectionName: String
        var sectionContents: [TaskCell]!
    }
 
    var highPriorityTasks: Array<TaskCell> = []
    var mediumPriorityTasks: Array<TaskCell> = []
    var lowPriorityTasks: Array<TaskCell> = []
    
    var allTasks = [Objects]()
    
    var shouldSegue: Bool = false
    
    var elementIndex: Int = 0
    var sectionIndex: Int = 0
    
    var docID: String = ""
    var docIDforMedium: String = ""
    
    var clickEditButton = 0
    
    var highPriorityFirebaseRef: CollectionReference!
    var mediumPriorityFirebaseRef: CollectionReference!
    var lowPriorityFirebaseRef: CollectionReference!
    
    var namesArray: Array<String>!
  //  var isEditing: Bool {setEditing(true, animated: false)}
    
    var notes: String = ""
    
    @IBOutlet weak var tableView: UITableView! //https://stackoverflow.com/questions/33724190/ambiguous-reference-to-member-tableview
    
    
    @IBOutlet var addButton: UIBarButtonItem!
    
    @IBOutlet var deleteTask: UIBarButtonItem!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allTasks[section].sectionContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
      
       cell.labelOutlet.text = allTasks[indexPath.section].sectionContents[indexPath.row].name

        return cell
    }
    
    
    @IBAction func addButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "addTaskLink", sender: nil)
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
        
        performSegue(withIdentifier: "notesLink", sender: Any?.self)
        
        shouldSegue = false
       // if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark //https://www.youtube.com/watch?v=5MZ-WJuSdpg
        
    

            //tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    
            /*
        else
        {
            if (clickEditButton % 2 == 0)
            {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        }
        tableView.deselectRow(at: indexPath, animated: true) //https://stackoverflow*.com/questions/33046573/why-do-my-uitableviewcells-turn-grey-when-i-tap-on-them/33046735
 */
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
                
                notesViewControllerRef.sectionIndex = sectionIndex
                notesViewControllerRef.elementInHighPriority = elementIndex
                notesViewControllerRef.elementInMediumPriority = elementIndex
            }
        }

    }

 
   
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    /*
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 */
 
    @IBAction func startEditing(_ sender: Any)
    {
//        self.navigationItem.rightBarButtonItem = nil
//
//        clickEditButton += 1
//
//        if(clickEditButton % 2 == 1)
//        {
//            //tableView.allowsMultipleSelection = true
//            tableView.allowsMultipleSelectionDuringEditing = true
//            tableView.setEditing(true, animated: false)
//        }
//        else
//        {
//            tableView.setEditing(false, animated: false)
//            self.navigationItem.rightBarButtonItem = self.addButton
//        }
        self.performSegue(withIdentifier: "addTaskLink", sender: self)
    }
    
    /*
    @IBAction func deleteRows(_ sender: Any)
    {
        
        if tableView.indexPathsForSelectedRows != nil
        {
            var selectedRows = tableView.indexPathsForSelectedRows!

            for indexPath in selectedRows  {
               // items.append(numbers[indexPath.row])
                highPriorityTasks.append(String(allTasks[indexPath.row]))
            }
        
        }
    }
    */
 
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        if(addButton.isEnabled)
//        {
//          print ("success")
//        }
        
      //  self.performSegue(withIdentifier: "addTaskLink", sender: self)
        
      // self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        highPriorityFirebaseRef = Firestore.firestore().collection("highPriorityTasks")
        mediumPriorityFirebaseRef = Firestore.firestore().collection("mediumPriorityTasks")
        lowPriorityFirebaseRef = Firestore.firestore().collection("lowPriorityTasks")
        trial()
        trialMedium()
   
        NotificationCenter.default.addObserver(self, selector: #selector(reloadList(_:)), name: NSNotification.Name("updateTableHighPriority"), object: nil) //creates the notification center named 'updateTable' and calls the function reloadList when it recieves the data
    
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListforMedium(_:)), name: NSNotification.Name("updateTableMediumPriority"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListforLow(_:)), name: NSNotification.Name("updateTableLowPriority"), object: nil)
        
       //  NotificationCenter.default.addObserver(self, selector: #selector(updateNotes(_:)), name: NSNotification.Name("updateNotes"), object: nil) //NOTES
        
        self.tableView.reloadData()
        loadTask()
        

 
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
                  //  newTask.update()
                    
                    
                    self.highPriorityTasks.append(newTask)
                  
                    
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
                    
                    
                    self.mediumPriorityTasks.append(newTask)
                  
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
                    
                    
                    self.lowPriorityTasks.append(newTask)
                  
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

