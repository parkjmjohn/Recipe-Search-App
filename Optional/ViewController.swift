//
//  ViewController.swift
//  Optional
//
//  Created by John Park on 11/26/17.
//  Copyright © 2017 John Park. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Spacing
    let padding1: CGFloat = 8
    let padding2: CGFloat = 16
    let padding3: CGFloat = 5
    let padding4: CGFloat = 50
    
    // MARK: UI
    var searchBar: UITextField!
    var searchButton: UIButton!
    var tableView: UITableView!
//DEBUG    var debug: UITextView!
    
    // MARK: Networking Data
    var recipes: [recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Recipes"
        view.backgroundColor = .white
        
        // MARK: Search Bar
        searchBar = UITextField(frame: CGRect(x: padding1, y: padding1 * 10, width: view.frame.width - padding2 * 5, height: padding2 * 1.5))
        searchBar.borderStyle = .line
        view.addSubview(searchBar)
        
        // MARK: Search Button
        searchButton = UIButton(frame: CGRect(x: view.frame.width - padding1 * 8, y: padding1 * 10 - padding3, width: 0, height: 0))
        searchButton.addTarget(self, action: #selector(didPressSearchButton), for: .touchUpInside)
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.blue, for: .normal)
        searchButton.sizeToFit()
        view.addSubview(searchButton)
        
        // MARK: Recipe Table
        tableView = UITableView(frame: CGRect(x: 0, y: padding1 * 15, width: view.frame.width, height: view.frame.height - padding1 * 15))
        tableView.rowHeight = padding4 * 2
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(recipeCell.self, forCellReuseIdentifier: "recipeCell")
        view.addSubview(tableView)
        
//DEBUG        debug = UITextView(frame: CGRect(x: 0, y: 200, width: 400, height: 400))
//DEBUG        view.addSubview(debug)
    }
    
    @objc func didPressSearchButton(){
        title = "Searching..."
        print("Programmer's Notes: user pressed search button")
        
        // MARK: Search Bar
        var holder: String!
        holder = searchBar.text
        searchBar.text = ""
        searchBar.placeholder = holder
        
        // MARK: Networking
        if holder != "" {
            let ret = holder.replacingOccurrences(of: " ", with: "")
            let urlString = "http://www.recipepuppy.com/api/?q=" + ret
            let url = URL(string: urlString)!
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        let json = JSON(json)
                        if (json["results"].array?.first?["title"].string) != nil {
                            var counter: Int = 0
                            self.recipes.removeAll()
                            while counter != json["results"].array?.count {
                                let title: String = (json["results"].array?[counter]["title"].string)!
                                let ingredients: String = (json["results"].array?[counter]["ingredients"].string)!
                                print("Programmer's notes: " + title + " " + ingredients)
                                self.recipes.append(recipe(title: title, ingredients: ingredients))
                                counter += 1
                            }
                            if ret == "" {
                                self.title = "Recipe For The Day"
                            } else {
                                self.title = "Results For: " + ret
                            }
                            self.tableView.reloadData()
                        } else {
                            self.title = "No Results Found"
                            self.recipes.removeAll()
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }

    // MARK: TableView Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! recipeCell
        cell.setUp(Recipe: recipes[indexPath.row])
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

