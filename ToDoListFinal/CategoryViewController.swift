//
//  CategoryViewController.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 15/11/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet var folderView: UITableView!
    
    var allFolders = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       // return allFolders.count
        return allFolders.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as! folderCell
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = allFolders[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "folderMainLink", sender: Any?.self)
    }
    
    
    var shouldSegue: Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFolders(_:)), name: NSNotification.Name("updateFolderName"), object: nil)

        // Do any additional setup after loading the view.
    }
    
   @objc func reloadFolders(_ notification: NSNotification)
   {
       if let info = notification.userInfo as NSDictionary? //sets a variable as the information from the dictionary recieved from the Notification
        {
            if let stringFromUser = info["folderName"] as? String //sets a variable as the information from the key 'task'
            {
                allFolders.append(stringFromUser)
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
