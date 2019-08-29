//
//  AddTaskController.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 21/7/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit


class AddTaskController: UIViewController {

    @IBOutlet weak var taskAdd: UITextField! //user's text from the textfield
    var clickedHighPriority = false
    var clickedMediumPriority = false
    var clickedLowPriority = false
    
    @IBOutlet weak var selectionHighPriority: UIButton!
    @IBOutlet weak var selectionMediumPriority: UIButton!
    @IBOutlet weak var selectionLowPriority: UIButton!
    
    
    var unclickHighPriority = 0
    var unclickMediumPriority = 0
    var unclickLowPriority = 0

    
    @IBOutlet weak var labelText: UILabel!
    
    @IBAction func addTask(_ sender: Any)
    {
        if let task = taskAdd.text, !task.isEmpty
        {
            let userInput: [String: String] = ["task" : task] //putting the user input into a dictorionary with the key 'task'
            
            if clickedHighPriority
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTableHighPriority"), object: nil, userInfo: userInput) //uses notification and calls the notification center made in ViewController called 'updateTable' and sends in the dictionary userInput
        
                returnToViewController()
            }
            
            if clickedMediumPriority
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTableMediumPriority"), object: nil, userInfo: userInput)
            
                returnToViewController()
            }
            
            if clickedLowPriority
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTableLowPriority"), object: nil, userInfo: userInput)
                
                returnToViewController()
            }
            
            if !clickedLowPriority && !clickedMediumPriority && !clickedHighPriority
            {
                labelText.text = "Please select a priority"
            }
        }
        else
        {
            labelText.text = "Please type a task"
        }
    }
    
    @IBAction func clickHighPriority(_ sender: Any)
    {
        selectionHighPriority.isSelected = !selectionHighPriority.isSelected //https://stackoverflow.com/questions/11181340/keeping-a-uibutton-pressedstate-selected-highlighted-until-another-button-is-p
        
        unclickHighPriority+=1
        if (unclickHighPriority % 2 == 1)
        {
        clickedHighPriority = true
        }
        else
        {
        clickedHighPriority = false
        }
    }
    
    @IBAction func clickMediumPriority(_ sender: Any)
    {
        selectionMediumPriority.isSelected = !selectionMediumPriority.isSelected
        
        unclickMediumPriority += 1
        if (unclickMediumPriority % 2 == 1)
        {
            clickedMediumPriority = true
        }
        else
        {
            clickedMediumPriority = false
        }
    }
    
    @IBAction func clickedLowPriority(_ sender: Any)
    {
        selectionLowPriority.isSelected = !selectionLowPriority.isSelected
        
        unclickLowPriority += 1
        if (unclickLowPriority % 2 == 1)
        {
            clickedLowPriority = true
        }
        else
        {
            clickedLowPriority = false
        }
    }
    
    func returnToViewController()
    {
        navigationController?.popViewController(animated: true) //brings it back to the ViewController page
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
