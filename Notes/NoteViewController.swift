//
//  NoteViewController.swift
//  Notes
//
//  Created by Ivan Uvarov on 11/11/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {

    // Our Text View
    @IBOutlet weak var noteTextView: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title for the screen
        self.navigationItem.title = "Note"
        
        // Add text of current note to the Text View
        noteTextView.text = notes[currentIndex]
        noteTextView.delegate = self
        
        // Start editing
        setStateEdit()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveNoteText()
    }
    
    

    func textViewDidBeginEditing(textView: UITextView) {
        setStateEdit()
    }
    
    
    
    func setStateEdit() {
        // Make Text View "active" (set cursor and open keyboard)
        noteTextView.becomeFirstResponder()
        
        // Create done button and add it to the view
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("setStateRead"))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func setStateRead() {
        // Close keyboard
        noteTextView.resignFirstResponder()
        
        // Remove done button
        self.navigationItem.rightBarButtonItem = nil
        
        // Save data
        saveNoteText()
    }
    
    
    
    func saveNoteText() {
        notes[currentIndex] = noteTextView.text
        masterView?.saveData()
    }
}
