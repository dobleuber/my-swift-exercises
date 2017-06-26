//
//  ViewController.swift
//  Challenge4
//
//  Created by Wbert Castro on 22/06/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var letterButtons = [UIButton]()
    var alphabet =  Array("abcdefghijklmnopqrstuvwxyz".uppercased().characters)
    var currentWord: [Character] = []
    var maskedWord: [Character] = [] {
        didSet {
            wordLabel.text = String(maskedWord)
        }
    }
    
    var lives: Int = 0 {
        didSet {
            livesLabel.text = "Lives: \(lives)"
        }
    }

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maskedWord = []
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterClicked(button:)), for: .touchUpInside)
        }
        
        for i in 0 ..<  alphabet.count  {
            letterButtons[i].setTitle(String(alphabet[i]), for: .normal)
        }
        
        lives = 7
        newWord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newWord() {
        let urlString = "http://setgetgo.com/randomword/get.php"
        if let url = URL(string: urlString) {
            if let word = try? String(contentsOf: url) {
                currentWord = [Character](word.uppercased().characters)
                let mask = String(repeating: "_", count: currentWord.count)
                maskedWord = [Character](mask.characters);
            }
        }
    }
    
    func newGame(action: UIAlertAction) {
        lives = 7
        newWord()
        
        for btn in letterButtons {
            btn.isEnabled = true
            btn.setTitleColor(.blue, for: .disabled)
        }
    }
    
    func letterClicked(button: UIButton) {
        let selectedLetter = button.title(for: .normal)!
        var isCorrect = false
        for i in 0 ..< currentWord.count {
            let currentChar = String(currentWord[i])
            if  currentChar == selectedLetter {
                isCorrect = true
                let selectedChar = Character(selectedLetter)
                currentWord[i] = selectedChar
                maskedWord[i] = selectedChar
            }
        }
        
        button.isEnabled = false
        
        if !isCorrect {
            button.setTitleColor(.red, for: .disabled)
            lives -= 1
            if lives == 0 {
                let ac = UIAlertController(title: "You lose!", message: "I'm sorry, you lose :-(", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: newGame))
                present(ac, animated: true)
            }
        } else {
            button.setTitleColor(.green, for: .disabled)
            if !maskedWord.contains("_") {
                let ac = UIAlertController(title: "You Won!", message: "Congratulations, You Won :-D", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: newGame))
                present(ac, animated: true)
            }
        }
    }
}

