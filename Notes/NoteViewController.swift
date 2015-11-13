//
//  NoteViewController.swift
//  Notes
//
//  Created by Ivan Uvarov on 11/11/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var noteTextView: UITextView!
    var doneButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Note"
        
        
        if Objects[selectedIndex] == BLANK_NOTE {
            noteTextView.text = ""
        }
        else {
            noteTextView.text = Objects[selectedIndex]
        }
        
        noteTextView.becomeFirstResponder()
        noteTextView.delegate = self
        
        setStateEdit()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        setStateEdit()
    }
    
    func setStateEdit() {
        noteTextView.becomeFirstResponder()
        doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("setStateRead"))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func setStateRead() {
        noteTextView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = nil
        saveAndUpdate()
    }
    
    func saveAndUpdate() {
        Objects[selectedIndex] = noteTextView.text
        masterView?.save()
        masterView?.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveAndUpdate()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
