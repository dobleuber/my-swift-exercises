//
//  DetailViewController.swift
//  Challenge2
//
//  Created by Wbert Castro on 13/06/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {
    @IBOutlet weak var countryImageView: UIImageView!
    
    var selectedCountry: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedCountry
        if let flagToLoad = selectedCountry {
            countryImageView.image = UIImage(named: flagToLoad)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
    }
    
    func shareFlag() ->  Void {
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText("Checkout this amazing flag!")
            vc.add(countryImageView.image)
            present(vc, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
