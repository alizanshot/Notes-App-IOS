//
//  CoreDataHelper.swift
//  MakeSchoolNotes
//
//  Created by Alizandro Lopez on 7/7/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Below we create a computed class variable that gets a reference to our app delegate's managed object context. We can use our reference to our NSManagedObjectContext to create, edit and delete NSManagedObject objects. This is the explanation that makeschool gave, but still a little confused
struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    //this method creates new note object and then returns it.  The NSEntity stuff is just methods
    //that swift already provided us we just fill in the parameters
    static func newNote() -> Note{
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        return note
    }
    //this saves the note
    static func saveNote(){
        do{
            try context.save()
        }catch {
            print("Failed saving")
        }
    }
    
    //this deletes the note
    static func delete(note: Note){
        context.delete(note)
        
        //don't know why we call this. Shouldn't it be reloaddata()?
        saveNote()
    }
    
    //this method retrieves all nots from our NSManagedObjectContext
    static func retrieveNotes() -> [Note]{
        do{
            let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
            let results = try context.fetch(fetchRequest)
            
            return results
        }catch{
            print("Could not Fetch")
            
            return[]
        }
    }
    
}


