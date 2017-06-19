//
//  SingleNoteViewControllerDelegate.swift
//  Notes Clone
//
//  Created by Robert G Tichy on 6/19/17.
//  Copyright © 2017 Robert G Tichy. All rights reserved.
//

import UIKit

protocol SingleNoteViewControllerDelegate: class {
    func save(controller: SingleNoteViewController, note: Note, atRow: NSIndexPath?)
}
