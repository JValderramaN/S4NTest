//
//  PersonsTableViewController.swift
//  S4NTest
//
//  Created by José Valderrama on 17/11/2018.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit

class PersonsTableViewController: UITableViewController {

    let personViewModel = PersonViewModel()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        personViewModel.currentPerson = nil
        personViewModel.updatePersons()
        tableView.reloadData()
    }

    private func configureTable() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PersonTableViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "PersonTableViewCell")
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personViewModel.persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell") as? PersonTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
        
        cell.configureCell(with: personViewModel.persons[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        personViewModel.currentPerson = personViewModel.persons[indexPath.row]    
        performSegue(withIdentifier: "PersonViewController", sender: nil)
    }
    
    // MARK: - Navegation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonViewController" {
            let personViewController = segue.destination as? PersonViewController
            personViewController?.personViewModel = personViewModel
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "PersonViewController", sender: nil)
    }
}

