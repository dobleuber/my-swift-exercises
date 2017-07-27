//
//  ViewController.swift
//  Challenge7
//
//  Created by Wbert Castro on 26/07/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNote))
        
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            notes = NSKeyedUnarchiver.unarchiveObject(with: savedNotes) as! [Note]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        
        cell.textLabel!.text = notes[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.note = notes[indexPath.row].text
            vc.rowIndex = indexPath.row
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func newNote() {
        notes.insert(Note("New note"), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func saveNote(_ note: String, at index: Int) {
        notes[index].text = note
        saveNotes()
    }
    
    func deleteNote(at index: Int) {
        notes.remove(at: index)
        saveNotes()
    }
    
    func saveNotes() {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: notes)
        UserDefaults.standard.set(savedData, forKey: "notes")
        tableView.reloadData()
    }
}

