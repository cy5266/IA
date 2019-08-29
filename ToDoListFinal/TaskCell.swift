//
//  TaskCell.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 22/7/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    
   // @IBOutlet weak var checkBoxOutlet: UIButton! //need to redrag later
    
    @IBOutlet weak var labelOutlet: UILabel!
    
    let checkBoxFilledImage = UIImage(named: "checkBoxFILLED")
    
    /*
    @IBAction func checkBoxAction(_ sender: Any)
    {
        checkBoxOutlet.setImage(checkBoxFilledImage, for: UIControl.State.normal)
    }
 */
}
