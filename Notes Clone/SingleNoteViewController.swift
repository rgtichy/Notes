//
//  SingleNoteViewController.swift
//  Notes Clone
//
//  Created by Robert G Tichy on 6/19/17.
//  Copyright © 2017 Robert G Tichy. All rights reserved.
//

import UIKit
import CoreData

class SingleNoteViewController: UIViewController {

    let coreDataObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    weak var delegate: SingleNoteViewControllerDelegate?
    
    var parmNote: Note?
    var parmIndexPath: NSIndexPath?

    @IBOutlet weak var inputArea: UITextView!
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        parmNote?.body = inputArea.text
        if coreDataObjectContext.hasChanges {
                save()
                print("Stored/changed a note")
        }
        
        dismiss(animated: true, completion: nil)
    }
    func save() {
        print("INSIDE SingleNoteViewController: save")
            if ((parmIndexPath) != nil) {
                delegate?.save(controller: self, note: parmNote!, atRow: parmIndexPath)
            } else {
                delegate?.save(controller: self, note: parmNote!, atRow: nil)
            }
            self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if parmIndexPath != nil {
            inputArea.text = parmNote?.body
        }
        else {
            print("add mode")
            inputArea.text = ""
        }
        inputArea.updateFocusIfNeeded()
    }
    
}
