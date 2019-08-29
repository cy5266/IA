//
//  ViewController.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 20/7/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    struct Objects //https://www.youtube.com/watch?v=zFMSovtqqUc
    {
        var sectionName: String
        var sectionContents: [String]!
    }
 
    var highPriorityTasks: Array<String> = []
    var mediumPriorityTasks: Array<String> = []
    var lowPriorityTasks: Array<String> = []
    var allTasks = [Objects]()
    var clickEditButton = 0
  //  var isEditing: Bool {setEditing(true, animated: false)}
    
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
      
        cell.labelOutlet.text = allTasks[indexPath.section].sectionContents[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark //https://www.youtube.com/watch?v=5MZ-WJuSdpg
        {

            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        else
        {
            if (clickEditButton % 2 == 0)
            {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        }
        tableView.deselectRow(at: indexPath, animated: true) //https://stackoverflow.com/questions/33046573/why-do-my-uitableviewcells-turn-grey-when-i-tap-on-them/33046735
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
        self.navigationItem.rightBarButtonItem = nil
        
        clickEditButton += 1
        
        if(clickEditButton % 2 == 1)
        {
            //tableView.allowsMultipleSelection = true
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.setEditing(true, animated: false)
        }
        else
        {
            tableView.setEditing(false, animated: false)
            self.navigationItem.rightBarButtonItem = self.addButton
        }
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
        

      // self.navigationItem.leftBarButtonItem = self.editButtonItem

        NotificationCenter.default.addObserver(self, selector: #selector(reloadList(_:)), name: NSNotification.Name("updateTableHighPriority"), object: nil) //creates the notification center named 'updateTable' and calls the function reloadList when it recieves the data
    
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListforMedium(_:)), name: NSNotification.Name("updateTableMediumPriority"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListforLow(_:)), name: NSNotification.Name("updateTableLowPriority"), object: nil)
        

        loadTask()
 
    }
    
   
    @objc func reloadList(_ notification: NSNotification) //load data here
    {
        if let info = notification.userInfo as NSDictionary? //sets a variable as the information from the dictionary recieved from the Notification
        {
            if let stringFromUser = info["task"] as? String //sets a variable as the information from the key 'task'
            {
                highPriorityTasks.append(stringFromUser) //adds the string from user into the array
            }
        }
        loadTask()
        self.tableView.reloadData() //redisplays everything in the array
    }
    
    @objc func reloadListforMedium(_ notification: NSNotification)
    {
        if let info = notification.userInfo as NSDictionary? //sets a variable as the information from the dictionary recieved from the Notification
        {
            if let stringFromUser = info["task"] as? String //sets a variable as the information from the key 'task'
            {
                mediumPriorityTasks.append(stringFromUser) //adds the string from user into the array
            }
        }
        loadTask()
        self.tableView.reloadData() //redisplays everything in the array
    }
    
    @objc func reloadListforLow(_ notification: NSNotification)
    {
        if let info = notification.userInfo as NSDictionary? //sets a variable as the information from the dictionary recieved from the Notification
        {
            if let stringFromUser = info["task"] as? String //sets a variable as the information from the key 'task'
            {
                lowPriorityTasks.append(stringFromUser) //adds the string from user into the array
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

