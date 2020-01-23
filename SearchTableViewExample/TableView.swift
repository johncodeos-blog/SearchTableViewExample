//
//  ViewController.swift
//  SearchTableViewExample
//
//  Created by John Codeos on 1/18/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import UIKit

class TableView: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    
    var countryList = [String]()
    
    var searchedCountry = [String]()
    var searching = false
    
    var selected: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.delegate = self
        
        // Change the Tint Color
        self.searchBar.barTintColor = UIColor.colorFromHex("#BC214B")
        self.searchBar.tintColor = UIColor.white
        // Show/Hide Cancel Button
        self.searchBar.showsCancelButton = true
        // Change TextField Colors
        let searchTextField = self.searchBar.searchTextField
        searchTextField.textColor = UIColor.white
        searchTextField.clearButtonMode = .never
        searchTextField.backgroundColor = UIColor.colorFromHex("#9E1C40")
        // Change Glass Icon Color
        let glassIconView = searchTextField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = UIColor.colorFromHex("#BC214B")
        
        
        self.searchBar.keyboardAppearance = .dark
        
        self.tableView.separatorStyle = .none
        self.tableView.tintColor = UIColor.white
        self.tableView.backgroundColor = UIColor.colorFromHex("#9E1C40")
        
        self.listOfCountries()
    }
    
    func listOfCountries() {
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countryList.append(name + " " + countryFlag(country: code))
            tableView.reloadData()
        }
    }
    
    // Add Flag Emoji
    func countryFlag(country: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsviewcontrollerseg" {
            let DestViewController = segue.destination as! DetailsViewController
            DestViewController.selectedCountry = selected
        }
    }
}

extension TableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCountry.count
        } else {
            return countryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if searching {
            cell.textLabel?.text = searchedCountry[indexPath.row]
        } else {
            cell.textLabel?.text = countryList[indexPath.row]
        }
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = UIColor.colorFromHex("#BC214B")
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            let selectedCountry = searchedCountry[indexPath.row]
            selected = selectedCountry
        } else {
            let selectedCountry = countryList[indexPath.row]
            selected = selectedCountry
        }
        performSegue(withIdentifier: "detailsviewcontrollerseg", sender: self)
        // Remove highlight from the selected cell
        tableView.deselectRow(at: indexPath, animated: true)
        // Close keyboard when you select cell
        self.searchBar.searchTextField.endEditing(true)
    }
}

extension TableView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = countryList.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
