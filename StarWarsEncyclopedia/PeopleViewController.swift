//
//  ViewController.swift
//  StarWarsEncyclopedia
//
//  Created by Shahad Nasser on 19/12/2021.
//

import UIKit

class PeopleViewController: UITableViewController {
    
    var people: [String] = Array()
    var url = URL(string: "https://swapi.dev/api/people/?format=json")

    private var pendingWorkItem: DispatchWorkItem?
    let queue = DispatchQueue(label: "GetPeopleQueue")
    
    var nextPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
            fetch()
    }
    
    func fetch() {
           pendingWorkItem?.cancel()
           let newWorkItem = DispatchWorkItem {
                self.getPeople()
           }
           pendingWorkItem = newWorkItem
           queue.sync(execute: newWorkItem)
    }
    
    func getPeople(){
        let session = URLSession.shared
        let task = session.dataTask(with: self.url!, completionHandler: {
            data, response, error in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                    if let nextUrl = jsonResult["next"] as? String{
                        self.url = URL(string: nextUrl)
                    }else{
                        self.nextPage = false
                    }
                    if let results = jsonResult["results"] as? [[String:Any]] {
                        
                        let resultsArray = results
                        for result in resultsArray {
                            let name = result["name"] as! String
                            self.people.append(String(name))
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        if self.nextPage{
                            self.getPeople()
                        }else{
                            return
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
        return people.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = people[indexPath.row]
        return cell
    }


}

