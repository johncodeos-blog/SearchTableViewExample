//
//  DetailsViewController.swift
//  SearchTableViewExample
//
//  Created by John Codeos on 1/18/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var selectedCountryLabel: UILabel!
    
    var selectedCountry: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCountryLabel.text = selectedCountry
    }
}
