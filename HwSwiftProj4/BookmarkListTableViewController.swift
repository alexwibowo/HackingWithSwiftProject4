//
//  BookmarkListTableViewController.swift
//  HwSwiftProj4
//
//  Created by Alex Wibowo on 14/9/21.
//

import UIKit

class BookmarkListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Bookmark.urls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebCell", for: indexPath)
        cell.textLabel?.text = Bookmark.urls[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWeb = Bookmark.urls[indexPath.row]
        
        guard let webController = storyboard?.instantiateViewController(identifier: "WebController") as? ViewController else {
            
            fatalError("Unable to create web controller")
        }
        webController.initialWeb = selectedWeb
        navigationController?.pushViewController(webController, animated: true)
        
    }

}
