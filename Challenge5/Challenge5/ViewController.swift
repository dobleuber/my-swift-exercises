//
//  ViewController.swift
//  Challenge5
//
//  Created by Wbert Castro on 10/07/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let files = try! fm.contentsOfDirectory(atPath: path)
        
        for file in files {
            if file.hasPrefix("nssl") {
                pictures.append(file)
            }
        }    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as! StormCell
        let fileName = pictures[indexPath.item]
        cell.name.text = fileName
        cell.imageView.image = UIImage(named: fileName)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

