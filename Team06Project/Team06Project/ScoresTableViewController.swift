//  Nihal Shetty (ndshetty)
//  Isha Ghaisas (ighaisas)
//  App Name: Team06Project (2048Game)
//  GitHub Submission Date: 05/06/2025
//
//  ScoresTableViewController.swift
//  Team06Project
//
//  Created by Ghaisas, Isha Milind on 4/27/25.
//

import UIKit

struct GameScore: Codable {
    let score: Int
    let moves: Int
    let date: Date
}

class ScoresTableViewController: UITableViewController {

    var highScores: [GameScore] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadScores()
        NotificationCenter.default.addObserver(self, selector: #selector(scoresUpdated), name: .scoresUpdated, object: nil)
    }
    
    @objc func scoresUpdated() {
        loadScores()
        tableView.reloadData()
    }
    
    func loadScores() {
        let decoder = PropertyListDecoder()
        let url = getScoresFileURL()
       
        if let data = try? Data(contentsOf: url),
           let decoded = try? decoder.decode([GameScore].self, from: data) {
            highScores = decoded
        } else {
            highScores = []
        }
    }
    func getScoresFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("scores.plist")
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        let score = highScores[indexPath.row]
       
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
       
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
        Score: \(score.score)
        Moves: \(score.moves)
        Date: \(formatter.string(from: score.date))
        """
        return cell
    }
}
