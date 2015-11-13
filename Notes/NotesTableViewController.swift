//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Ivan Uvarov on 11/11/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit


// Views
var masterView:NotesTableViewController?
var detailViewController:NoteViewController?

// Data
var notes = [String]()
var currentIndex = 0

// Constants
let kNotes = "notes"



class NotesTableViewController: UITableViewController {
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add table footer to hide empty cells
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        
        // Load data from user defaults and set the background
        loadData()
        setBackground()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Every time view is about to appear - reload table data
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Check is curentIndex is invalid
        if (currentIndex > notes.count - 1) {
            currentIndex = 0
        }
        
        // If curent note is empty, remove it
        if (notes.count != 0 && notes[currentIndex] == "") {
            removeRowAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0))
        }
        
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func newNoteButton(sender: AnyObject) {
        
        // Add new empty note
        notes.insert("", atIndex: 0)
        
        // Check if background should be updates
        setBackground()
        
        // Reload table and show new note
        self.tableView.reloadData()
        
        // Set selected note and trigger the segue
        currentIndex = 0
        self.performSegueWithIdentifier("showNote", sender: self)
    }
    
    
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // What happens when you user deletes a row
        if editingStyle == .Delete {
            removeRowAtIndexPath(indexPath)
        }
    }
    

    
    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // We have only 1 section in Table View
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of rows equals to number of string in our notes array
        return notes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Set label text to be note text
        cell.textLabel!.text = notes[indexPath.row]

        return cell
    }

    
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Before moving to the note view, set currentIndex to the index of selected note
        if segue.identifier == "showNote" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                currentIndex = indexPath.row
            }
        }
    }
    
    
    
    // MARK: - Custom Functions
    
    // Removes note at a given index path
    func removeRowAtIndexPath(indexPath: NSIndexPath) {
        
        notes.removeAtIndex(indexPath.row)
        
        saveData()
        setBackground()
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    // Set background to an image if there're no notes, removes lines between rows
    func setBackground() {
        
        if notes.count == 0 {
            tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyTable"))
            tableView.backgroundView?.contentMode = .Center
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
    }
    
    // Saves notes data to User Defaults (persistent storage)
    func saveData() {
        NSUserDefaults.standardUserDefaults().setObject(notes, forKey: kNotes)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // Load data from persistent storage and saves it to a local variable
    func loadData() {
        if let loadedData = NSUserDefaults.standardUserDefaults().arrayForKey(kNotes) as? [String] {
            notes = loadedData
        }
    }

}
