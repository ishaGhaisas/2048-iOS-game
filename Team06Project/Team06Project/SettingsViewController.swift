//  Nihal Shetty (ndshetty)
//  Isha Ghaisas (ighaisas)
//  App Name: Team06Project (2048Game)
//  GitHub Submission Date: 05/06/2025
//
//  SettingsViewController.swift
//  Team06Project
//
//  Created by Ghaisas, Isha Milind on 4/27/25.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var colorThemeSegmentedControl : UISegmentedControl!
    @IBOutlet weak var boardSizeSegmentControl : UISegmentedControl!
    @IBOutlet weak var soundEffectsSwitch : UISwitch!
    @IBOutlet weak var wipeHighScoresButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in settings")
    }
    
    @IBAction func colorThemeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            ThemeManager.shared.currentTheme = .green
        } else {
            ThemeManager.shared.currentTheme = .blue
        }
    }

    @IBAction func boardSizeChanged(_ sender: UISegmentedControl) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if sender.selectedSegmentIndex == 0 {
                appDelegate.currentGridSize = 4
            } else if sender.selectedSegmentIndex == 1 {
                appDelegate.currentGridSize = 5
            }
        }

        NotificationCenter.default.post(name: Notification.Name("GridSizeChanged"), object: nil)
    }

    @IBAction func soundEffectsToggled(_ sender: UISwitch) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.soundEnabled = sender.isOn
        }
    }

    @IBAction func wipeHighScoresPressed(_ sender: UIButton) {
        let url = getScoresFileURL()

        do {
            try FileManager.default.removeItem(at: url)
            print("Scores wiped successfully.")
           
            NotificationCenter.default.post(name: .scoresUpdated, object: nil)
        } catch {
            print("Failed to wipe scores: \(error)")
        }
    }
       
    func getScoresFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("scores.plist")
    }
}
