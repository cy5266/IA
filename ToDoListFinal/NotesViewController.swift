//
//  NotesViewController.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 12/9/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit
import Firebase


class NotesViewController: UIViewController
{

    var notesFirebaseRef: CollectionReference!
    var currentTask: TaskCell!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //  notesFirebaseRef = Firestore.firestore().collection("notes")
      //  getDocuments()
    }
    
    @IBOutlet var extraNotes: UITextView!
    
    
    @IBAction func clickAdd(_ sender: Any)
    {
        if let notes = extraNotes.text, !extraNotes.text.isEmpty
        {
            let newNotes: [String: String] = ["note" : notes]
           // notesFirebaseRef.addDocument(data: ["note": notes])
        
           // returnToViewController()
           // getDocuments()
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateNotes"), object: nil, userInfo: newNotes)
        }
    }
    
    
    func getDocuments()
    {
        notesFirebaseRef.getDocuments()
            {
            (docsSnapshot, err) in
            if let err = err
            {
                print("error \(err)")
            }
            else
            {
                for document in docsSnapshot!.documents
                {
                    self.extraNotes.text = (document["note"] as! String)
                }
            }
            
         //   DispatchQueue.main.async
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
