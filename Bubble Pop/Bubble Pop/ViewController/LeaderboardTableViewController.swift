//
//  LeaderboardTableViewController.swift
//  Bubble Pop
//
//  Created by Jhon Rayo on 5/5/19.
//  Copyright © 2019 Jhon Stewar Rayo Mosquera. All rights reserved.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {
    
    var players: [Player] = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        populateTableFromCoreData()
    }
    
    func populateTableFromCoreData() {
        players = GameManager.getPlayers()
    }
    
    func performAnimation() {
        tableView.reloadData()
        
        for cell in tableView.visibleCells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableView.bounds.size.height)
        }
        
        var delayOffset = 0.0
        for cell in tableView.visibleCells {
            UIView.animate(withDuration: 2, delay: delayOffset * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {cell.transform = CGAffineTransform.identity}) { (success) in
                if success {
                    
                }
            }
            delayOffset += 1
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = players[indexPath.row].name
        cell.detailTextLabel?.text = String(players[indexPath.row].score)

        return cell
    }
    

}
