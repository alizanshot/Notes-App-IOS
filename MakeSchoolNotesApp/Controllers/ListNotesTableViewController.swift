//
//  ListNotesTableViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class ListNotesTableViewController: UITableViewController {
    
    //when a property is changed in our notes, it enters the didSet block and updates the tableview
    var notes = [Note](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes = CoreDataHelper.retrieveNotes()
    }
    
    //table view should display 10 tableviewcells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //checks if the instance of the new cell that was created was already used. Basically prevents viewController from creating infinite table view cells. the identifier is a specific string that connects it to correct tableviewController
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        let note = notes[indexPath.row]
        
        cell.noteTitleLabel.text = note.title
        cell.noteModificationTitleLabel.text = note.modificationTime?.convertToString() ?? "unknown"
        
        return cell
        
    }
    
   // we retrieve the note to be deleted corresponding to the selected index path. Then we use our Core Data helper to delete the selected note. Last we update our notes array to reflect the changes in our NSManagedObjectContext
    override func tableView(_ tableView: UITableView, commit editingSytle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingSytle == .delete{
            let noteToDelete = notes[indexPath.row]
            CoreDataHelper.delete(note: noteToDelete)
            
            notes = CoreDataHelper.retrieveNotes()
        }
    }
    
    @IBAction func unwindWithSegue(_ seugue: UIStoryboardSegue){
        notes = CoreDataHelper.retrieveNotes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let identifier = segue.identifier else {return}
        
        switch identifier{
        case "displayNote":
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let note = notes[indexPath.row]
            
            let destination = segue.destination as! DisplayNoteViewController
            
            destination.note = note
            
        case "addNote":
            print("note added")
            
        default:
            print("unknown")
        }
    }
    
}
