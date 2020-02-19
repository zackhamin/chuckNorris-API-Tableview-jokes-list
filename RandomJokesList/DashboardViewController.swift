//
//  DashboardViewController.swift
//  RandomJokesList
//
//  Created by Ishaq Amin on 18/02/2020.
//  Copyright © 2020 Ishaq Amin. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var clickToEnterButton: UIButton!
    @IBOutlet weak var explicitSwitch: UISwitch!
    
    @IBAction func urlSwitch(_ sender: UISwitch) {
        performSegue(withIdentifier: "goToTableView", sender: explicitSwitch)
    }
    //    @IBAction func enterButton(_ sender: UIButton) {
    //         performSegue(withIdentifier: "goToTableView", sender: clickToEnterButton)
    //    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is JokesTableViewController {
            let vc = segue.destination as? JokesTableViewController
            vc?.changeURL = explicitSwitch.isOn
        }
    }
}
