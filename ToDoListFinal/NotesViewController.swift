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
    
    var indexReference: String = ""
    var note: String = ""
    
   // var allIDS: Array<Any> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesFirebaseRef = Firestore.firestore().collection("highPriorityTasks")

        // Do any additional setup after loading the view.
      //  notesFirebaseRef = Firestore.firestore().collection("notes")
    }
    
    @IBOutlet var extraNotes: UITextView!
    
    
    @IBAction func clickAdd(_ sender: Any)
    {
        
       // print((allIDS[0] as AnyObject).documentID)
        
        if let notes = extraNotes.text, !extraNotes.text.isEmpty
        {
            /*
            let newNotes: [String: String] = ["note" : notes]
            notesFirebaseRef.addDocument(data: ["note": notes])
 */
            let test = notes;
            
            //need to get the docID of the document i clicked on and then add a field to it
            let everyDocument = notesFirebaseRef.document(indexReference)
            everyDocument.updateData(["notes": test])
            {
                err in
                if let err = err
                {
                    self.getDocuments()
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
            //notesFirebaseRef.addDocument(data: ["note": test])

           // returnToViewController()
    
            /*
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateNotes"), object: nil, userInfo: newNotes)
 */
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
                    self.note = document["notes"] as! String
                  //  self.extraNotes.text = note
                }
            }
            
        //DispatchQueue.main.async
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


