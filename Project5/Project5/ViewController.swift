//
//  ViewController.swift
//  Project5
//
//  Created by Wbert Castro on 6/06/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var currentWord = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            } else {
                allWords = ["silkworm"]
            }
        } else {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    func startGame() {
        if currentWord == 0 {
            allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        }
        
        title = allWords[currentWord]
        currentWord += 1
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "submit", style: .default) {
            [unowned self, ac] action  in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                } else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know"
                    showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
                showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'"
            showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
        }
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()
        
        for letter in word.characters {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return word != title?.lowercased() && !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if word.characters.count <= 3 {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

