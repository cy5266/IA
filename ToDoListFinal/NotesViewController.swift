//
//  NotesViewController.swift
//  ToDoListFinal
//
//  Created by Cindy Yang on 12/9/2019.
//  Copyright © 2019 Cindy Yang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class NotesViewController: UIViewController
{

    var notesFirebaseRef: CollectionReference!
    var notesMediumFirebaseRef: CollectionReference!
    var notesLowFirebaseRef: CollectionReference!
    
    var elementInHighPriority: Int = 0
    var elementInMediumPriority: Int = 0
    var elementInLowPriority: Int = 0
    
    var indexReference: String = ""
    var indexReferenceMedium: String = ""
    var indexReferenceLow: String = ""

    var sectionIndex: Int =  0
    var note: String = ""
    
    var notes: Array<Any> = []
    var notesForMedium: Array<Any> = []
    var notesForLow: Array<Any> = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        notesFirebaseRef = Firestore.firestore().collection("highPriorityTasks")
        notesMediumFirebaseRef = Firestore.firestore().collection("mediumPriorityTasks")
        notesLowFirebaseRef = Firestore.firestore().collection("lowPriorityTasks")
        getDocuments()
        updateNotes()

        // Do any additional setup after loading the view.
      //  notesFirebaseRef = Firestore.firestore().collection("notes")
    }
    
    @IBOutlet var extraNotes: UITextView!
    
    
    @IBAction func clickAdd(_ sender: Any) //The Save button used to be Add, so it's actually clickSave
    {
        
       // print((allIDS[0] as AnyObject).documentID)
        
        if let notes = extraNotes.text, !extraNotes.text.isEmpty
        {
            /*
            let newNotes: [String: String] = ["note" : notes]
            notesFirebaseRef.addDocument(data: ["note": notes])
 */
            let test = notes;
            
            
            if (sectionIndex == 0)
            {
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
                    self.getDocuments()
                    //  self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else if (sectionIndex == 1)
            {
                let newDocument = notesMediumFirebaseRef.document(indexReferenceMedium)
                print("pressed")
                newDocument.updateData(["notes": test])
                {
                    err in
                    if let err = err
                    {
                        self.getDocuments()
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        self.getDocuments()
                        //  self.navigationController?.popViewController(animated: true)
                        }
                    }
            }
            else if (sectionIndex == 2)
            {
                let newDocument = notesLowFirebaseRef.document(indexReferenceLow)
                print("pressed")
                newDocument.updateData(["notes": test])
                {
                    err in
                    if let err = err
                    {
                        self.getDocuments()
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        self.getDocuments()
                        //  self.navigationController?.popViewController(animated: true)
                        }
                    }
            }
            
            }

      //  viewDidLoad() //helped with the blinking problem
        }

    
    
    func getDocuments()
    {
        if (sectionIndex == 0)
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
                self.notes.removeAll()
                for document in docsSnapshot!.documents
                {
                    self.notes.append((document["notes"] as? String))
                }
            }
            
        DispatchQueue.main.async
            {
                self.updateNotes()
            }
           
        }
        }
        else if (sectionIndex == 1)
        {
            notesMediumFirebaseRef.getDocuments()
            {
                (docsSnapshot, err) in
                if let err = err
                {
                    print("error \(err)")
                }
                else
                {
                    self.notesForMedium.removeAll()
                    for document in docsSnapshot!.documents
                    {
                        self.notesForMedium.append((document["notes"] as? String))
                    }
                }
                
            DispatchQueue.main.async
                {
                    self.updateNotes()
                }
               
            }
        }
        
        else if (sectionIndex == 2)
        {
            notesLowFirebaseRef.getDocuments()
            {
                (docsSnapshot, err) in
                if let err = err
                {
                    print("error \(err)")
                }
                else
                {
                    self.notesForLow.removeAll()
                    for document in docsSnapshot!.documents
                    {
                        self.notesForLow.append((document["notes"] as? String))
                    }
                }
                
            DispatchQueue.main.async
                {
                    self.updateNotes()
                }
               
            }
        }
        
        
//        print(notes.count)
//        print(elementInHighPriority)
//        print(self.notes[elementInHighPriority])
       // updateNotes()
        // self.updateNotes()

    }
 
    func updateNotes()
    {
        if(!notes.isEmpty && (sectionIndex == 0))
        {
            self.extraNotes.text = notes[elementInHighPriority] as? String
            //extraNotes.reloadInputViews()
            
        }
        else if (!notesForMedium.isEmpty && (sectionIndex == 1))
        {
            self.extraNotes.text = notesForMedium[elementInMediumPriority] as? String
            // print(self.notes[elementInHighPriority])

            extraNotes.reloadInputViews()
        }
        else if (!notesForLow.isEmpty && (sectionIndex == 2))
        {
            self.extraNotes.text = notesForLow[elementInLowPriority] as? String
            // print(self.notes[elementInHighPriority])

            extraNotes.reloadInputViews()
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


