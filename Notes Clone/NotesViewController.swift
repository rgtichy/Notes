//
//  ViewController.swift
//  Notes Clone
//
//  Created by Robert G Tichy on 6/19/17.
//  Copyright © 2017 Robert G Tichy. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SingleNoteViewControllerDelegate {
    
    let coreDataObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var searchController = UISearchController(searchResultsController: nil)
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
     
    }
    
    var notes: [Note] = [Note]()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func newNotePressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EVANote", sender: nil)
    }
    func dumpNotes() {
        var idx: Int = 0
        for n in notes {
            print("\(idx):  title:\(n.body!), info: \(n.body!), date: \(n.lastUpdate!)")
            idx += 1
        }
    }
    func loadNotes() {
        do {
            print("loadNotes begin:")

            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            let sort = NSSortDescriptor(key: "lastUpdate", ascending: false)
            request.sortDescriptors = [sort]
            
            notes = try coreDataObjectContext.fetch(request) as! [Note]
            print("# of Notes: \(notes.count)")
//            dumpNotes()
        }
        catch {
            let readable_error = error as NSError
            print(readable_error)
        }
        print("end of loadNotes notes.count= \(notes.count)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        loadNotes()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EVANote", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("checked notes count: \(notes.count)")
        return notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("loading cells")
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell")!
        
        cell.textLabel?.text = notes[indexPath.row].body
//        cell.detailTextLabel?.text = notes[indexPath.row].lastUpdate as String
        let date = notes[indexPath.row].lastUpdate as! Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringDate = dateFormatter.string(from: date)
        cell.detailTextLabel?.text = stringDate
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let SingleNoteViewController = navigationController.topViewController as! SingleNoteViewController
        SingleNoteViewController.delegate = self
        print("\ninside PrepareForSegue")
        if sender is NSIndexPath {
            // the only segue with indexPath as sender is for open events accessory pressed
            let indexPath = sender as! NSIndexPath
            let note = notes[indexPath.row] 
            SingleNoteViewController.parmNote = note
            SingleNoteViewController.parmIndexPath = indexPath
        }
        else {
            let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: coreDataObjectContext) as! Note
            SingleNoteViewController.parmNote = note
            SingleNoteViewController.parmIndexPath = nil
        }
    }
    func save(controller: SingleNoteViewController, note: Note, atRow indexPath: NSIndexPath?) {
        print("returning to Main from Save")
        if coreDataObjectContext.hasChanges {
            do {
                print(note.body as Any)
                note.lastUpdate = Date() as NSDate?
                try coreDataObjectContext.save()
                print("Stored/changed a note")
                self.dismiss(animated: true, completion: nil)
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        loadNotes()
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let note = notes[indexPath.row]
        coreDataObjectContext.delete(note)
        notes.remove(at: indexPath.row)
        
        if coreDataObjectContext.hasChanges {
            do {
                try coreDataObjectContext.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        
        tableView.reloadData()
    }
    

}

