//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Ivan Uvarov on 11/11/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit

var masterView:NotesTableViewController?
var detailViewController:NoteViewController?

var Objects:[String] = [String]()
var selectedIndex = 0
let BLANK_NOTE = "New Note"

var kNotes = "notes"

class NotesTableViewController: UITableViewController {
    
    @IBAction func newNoteButton(sender: AnyObject) {
        Objects.insert(BLANK_NOTE, atIndex: 0)
        setBackground()
        save()
        self.tableView.reloadData()
        selectedIndex = 0
        self.performSegueWithIdentifier("showNote", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView.init(frame: CGRectZero)

        load()
        setBackground()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tableView.reloadData()
        
        if selectedIndex > Objects.count - 1 {
            selectedIndex = 0
        }
        
        if Objects.count != 0 && (Objects[selectedIndex] == BLANK_NOTE || Objects[selectedIndex] == "") {
            Objects.removeAtIndex(selectedIndex)
            save()
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: selectedIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = Objects[indexPath.row]

        return cell
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            Objects.removeAtIndex(indexPath.row)
            save()
            setBackground()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showNote" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                selectedIndex = indexPath.row
            }
        }
    }
    
    // MARK: - Custom Functions
    
    func setBackground() {
        if Objects.count == 0 {
            tableView.backgroundView = UIImageView(image: UIImage(named: "EmptyTable"))
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
    }
    
    func save() {
        NSUserDefaults.standardUserDefaults().setObject(Objects, forKey: kNotes)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func load() {
        if let loadedData = NSUserDefaults.standardUserDefaults().arrayForKey(kNotes) as? [String] {
            Objects = loadedData
        }
    }

}
