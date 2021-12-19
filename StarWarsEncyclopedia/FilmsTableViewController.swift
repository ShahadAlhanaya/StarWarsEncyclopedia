//
//  FilmsTableViewController.swift
//  StarWarsEncyclopedia
//
//  Created by Shahad Nasser on 19/12/2021.
//

import UIKit

class FilmsTableViewController: UITableViewController {
    
    var films: [String] = Array()
    var url = URL(string: "https://swapi.dev/api/films/?format=json")

    private var pendingWorkItem: DispatchWorkItem?
    let queue = DispatchQueue(label: "GetFilmsQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    
    }
    
    func fetch(){
        pendingWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem {
             self.getFilms()
        }
        pendingWorkItem = newWorkItem
        queue.sync(execute: newWorkItem)
    }
    
    func getFilms(){
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                    if let results = jsonResult["results"] as? [[String:Any]] {
                        
                        let resultsArray = results
                        for result in resultsArray {
                            let title = result["title"] as! String
                            self.films.append(String(title))
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }catch{
                print(error)
            }
        })
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = films[indexPath.row]
        return cell
    }

}
