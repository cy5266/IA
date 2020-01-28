//
//  folderCell.swift
//  ToDoListFinal
//
//  Created by CindyYang on 14/12/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit

class folderCell: UITableViewCell
{
    
    @IBOutlet var folderLable: UIView!
    
    var name: String = ""
    var documentID: String = ""
    
//    func update()
//       {
//       NotificationCenter.default.addObserver(self, selector: #selector(reloadList(_:)), name: NSNotification.Name("updateFolderName"), object: nil)
//           //allIDS.append(documentID)
//        //   return all
//       }
//       
//       @objc func reloadList(_ notification: NSNotification)
//       {
//           if let info = notification.userInfo as NSDictionary? //sets a variable as the information from the dictionary recieved from the Notification
//           {
//               if let stringFromUser = info["folderName"] as? String //sets a variable as the information from the key 'task'
//               {
//                  name = stringFromUser
//               }
//           }
//       }

}

