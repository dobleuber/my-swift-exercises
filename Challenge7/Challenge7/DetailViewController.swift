//
//  DetailViewController.swift
//  Challenge7
//
//  Created by Wbert Castro on 27/07/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {
    @IBOutlet weak var noteTextView: UITextView!
    var note: String?
    var rowIndex: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        
        navigationItem.rightBarButtonItems = [deleteButton, shareButton, saveButton]

        noteTextView.text = note
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            let top = noteTextView.contentInset.top
            noteTextView.contentInset = UIEdgeInsets.zero
            noteTextView.contentInset.top = top
            
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: noteTextView.contentInset.top, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        noteTextView.scrollIndicatorInsets = noteTextView.contentInset
        
        let selectedRange = noteTextView.selectedRange
        noteTextView.scrollRangeToVisible(selectedRange)
    }
    
    func saveNote() {
        navigationController?.popViewController(animated: true)
        let vc = navigationController?.viewControllers.last as! ViewController
        vc.saveNote(noteTextView.text!, at: rowIndex!)
    }
    
    func deleteNote() {
        navigationController?.popViewController(animated: true)
        let vc = navigationController?.viewControllers.last as! ViewController
        vc.deleteNote(at: rowIndex!)
    }
    
    func shareNote() {
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText(note)
            present(vc, animated: true)
        }
    }
}
