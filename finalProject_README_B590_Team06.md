# B590/Spring 2025 Team06Project - 2048 App - Final Project README

## Team Members
- Nihal Shetty (ndshetty)
- Isha Ghaisas (ighaisas)

---

## How to Interact with the App

Purpose of Each Screen:
- Game Screen:
  - The main 2048 gameplay board.
  - Swipe Left, Right, Up, Down to move tiles and merge matching tiles.
  - The Score and Best Score update based on gameplay.
  - Tap the Restart Button to start a new game.
  - A Game Over Prompt appears when no moves are left.
  - Animated "+Score" popups appear for every successful merge.
  - Sound effects are played on each move.

- Settings Screen:
  - Change Color Theme: Toggle between Green and Blue themes.
  - Change Board Size: Switch between 4x4 and 5x5 grids.
  - Sound Effects Toggle: Turn on/off move sound feedback.
  - Wipe All High Scores: Clears all previously saved scores.

- Scores Screen:
  - Displays a list of previous high scores, moves taken, and date/time.
  - Updates after the game ends or restarts.

---

## Development Environment

- Xcode Version Used: Xcode 16.2
- Tested Devices:
  - iPhone 16 Pro (iOS 18.4)
  - iPhone Simulator (iPhone 16 Pro)

---

## Completed Features (Mapped to Files)

| #  | Requirement | Where Implemented |
|----|-------------|-------------------|
| 1  | Multi-Screen Navigation (Main Game, Settings, Scores) | Storyboard, Tab Bar Controller |
| 2  | Gameplay (Swipe Gestures) | `GameViewController.swift` |
| 3  | Grid Drawing | `GridView.swift` |
| 4  | Persistent Storage | `GameViewController.swift`, `ScoresTableViewController.swift` |
| 5  | Settings Screen (theme change, board size, sounds, reset scores) | `SettingsViewController.swift`, `AppDelegate.swift` |
| 6  | Themes | `GridView.swift`, `GameViewController.swift` |
| 7  | SpriteKit Animations for Score | `GameViewController.swift` (`setupAnimationScene`, `scoreGainedAnimation`) |
| 8  | AVFoundation for Sound Effects | `GameViewController.swift` (`playMoveSound`) |
| 9  | Board Size (4x4 or 5x5) | `AppDelegate.swift`, `GameViewController.swift`, `GridView.swift`, `GameModel.swift` |
| 10 | Game Over alert | `GameModel.swift` (`isGameOver`), `GameViewController.swift` (`showGameOverAlert`) |
| 11 | Best Score Calculation | `GameViewController.swift` (`updateScore`) |
| 12 | Wipe All High Scores Functionality | `SettingsViewController.swift` (`wipeHighScoresPressed`) |

---

## Changes from Lab 13 / Homework 04 Designs

| Aspect | What Changed | Why | When | Where |
|--------|--------------|-----|------|-------|
| Sound Effects | Added move sound using AVFoundation | To increase user engagement during moves | After Lab 13 | `GameViewController.swift` (`playMoveSound`) |


---

## Division of Responsibilities

| Component | Responsible Team Member |
|-----------|--------------------------|
| Settings View (UI) | Isha Ghaisas|
| Score View (UI) | Isha Ghaisas|
| Game View (UI) | Nihal Shetty|
| Settings Functionality - Sound, Board Size, Themes | Nihal Shetty |
| Settings Functionality - Wipe Scores | Isha Ghaisas |
| Scores Screen Functionality | Isha Ghaisas |
| Game View Logic | Both Nihal Shetty and Isha Ghaisas |

