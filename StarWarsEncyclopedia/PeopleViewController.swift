//
//  ViewController.swift
//  StarWarsEncyclopedia
//
//  Created by Shahad Nasser on 19/12/2021.
//

import UIKit

class PeopleViewController: UITableViewController {
    var people: [String] = Array()
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://swapi.dev/api/people/?format=json")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                    print(jsonResult)
                    if let results = jsonResult["results"] as? [[String:Any]] {
                        
                        let resultsArray = results
//                        print(resultsArray.count)
//                        print(resultsArray[0])
//                        print(resultsArray.firstObject)
                        for result in resultsArray {
                            let name = result["name"] as! String
                            self.people.append(String(name))
                            print(result)
                        }
                        //self.people.append(fact as! String)
                        //print(fact)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                }
            }catch{
                print(error)
            }
//            print("im here")
//            print(data ?? "no data")
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

