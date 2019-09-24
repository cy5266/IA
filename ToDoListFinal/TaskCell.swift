//
//  TaskCell.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 22/7/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit
import Firebase

class TaskCell: UITableViewCell {
    
    
   // @IBOutlet weak var checkBoxOutlet: UIButton! //need to redrag later
    
    @IBOutlet weak var labelOutlet: UILabel!
    
    var name: String = ""
    
    var notes: String = ""
    
    var documentID: String = ""

    func update()
    {
    NotificationCenter.default.addObserver(self, selector: #selector(reloadList(_:)), name: NSNotification.Name("updateTableHighPriority"), object: nil)
        print("successful")
    }
    
    @objc func reloadList(_ notification: NSNotification)
    {
        if let info = notification.userInfo as NSDictionary? //sets a variable as the information from the dictionary recieved from the Notification
        {
            if let stringFromUser = info["task"] as? String //sets a variable as the information from the key 'task'
            {
               name = stringFromUser
            }
        }
    }
    
    /*
    @IBAction func checkBoxAction(_ sender: Any)
    {
        checkBoxOutlet.setImage(checkBoxFilledImage, for: UIControl.State.normal)
    }
 */
}
