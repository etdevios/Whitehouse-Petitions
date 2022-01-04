//
//  ViewController.swift
//  Project 7
//
//  Created by Eduard Tokarev on 03.01.2022.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        title = "Petitions"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))

        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
            
        }
        
        showError()
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc func creditsTapped() {
        let ac = UIAlertController(title: "Credits", message: "The petitions come from the We The People API of the Whitehouse", preferredStyle: .alert)
        
        
        let submitAction = UIAlertAction(title: "Close", style: .default)
        ac.addAction(submitAction)
        
        present(ac, animated: true)
        }
    
    @objc func search() {
        let ac = UIAlertController(title: "Filter petitions:", message: "Please enter the petitions you're searching for", preferredStyle: .alert)
        ac.addTextField()
        
        let clearAction = UIAlertAction(title: "Clear", style: .default) { [weak self] action in
            self?.copyPetitions()
        }
        
        ac.addAction(clearAction)
        
        let submitAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        
        
        
        present(ac, animated: true)
        
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        let petitionsStore = petitions
        var filter = [Petition]()
        
        for petition in petitionsStore {
            if petition.title.lowercased().contains(lowerAnswer) || petition.body.lowercased().contains(lowerAnswer) {
                filter.append(petition)
            }
        }
        
        if filter.isEmpty {
            noResults(answer)
            return
        }
        
        filteredPetitions.removeAll()
        filteredPetitions = filter
        tableView.reloadData()
        
    }
    
    func copyPetitions () {
        
        filteredPetitions.removeAll()
        filteredPetitions = petitions
        tableView.reloadData()
    }
    
    func noResults(_ answer: String) {
        let ac = UIAlertController(title: "No results:", message: "Nothing to see here: \(answer)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        ac.addAction(okAction)
        
        present(ac, animated: true)
    }
    

}

