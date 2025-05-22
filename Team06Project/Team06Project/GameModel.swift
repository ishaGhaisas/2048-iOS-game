//  Nihal Shetty (ndshetty)
//  Isha Ghaisas (ighaisas)
//  App Name: Team06Project (2048Game)
//  GitHub Submission Date: 05/06/2025
//
//  GameModel.swift
//  Team06Project
//
//  Created by Ghaisas, Isha Milind on 4/30/25.
//

import Foundation

class GameModel {
    var grid: [[Int]]
    var score: Int = 0
    var moves: Int = 0
    
    init(size: Int) {
        self.grid = Array(repeating: Array(repeating: 0, count: size), count: size)
    }
    
    func moveLeft() {
        var accumulatedScoreGain = 0
        var didMove = false

        for row in 0..<grid.count {
            let original = grid[row]
            let (newRow, scoreGained) = mergeRow(original)
            grid[row] = newRow
            if scoreGained > 0 {
                accumulatedScoreGain += scoreGained
            }
            if newRow != original {
                didMove = true
            }
        }

        if didMove {
            moves += 1
            spawnTile()
            NotificationCenter.default.post(name: Notification.Name("ScoreGained"), object: accumulatedScoreGain)
        }
    }
    
    func moveRight() {
        var didMove = false
        var accumulatedScoreGain = 0

        for row in 0..<grid.count {
            let original = grid[row]
            let reversed = original.reversed()
            let (merged, scoreGained) = mergeRow(Array(reversed))
            let newRow = Array(merged.reversed())
            grid[row] = newRow
            if newRow != original {
                didMove = true
            }
            accumulatedScoreGain += scoreGained
        }

        if didMove {
            moves += 1
            spawnTile()
            NotificationCenter.default.post(name: Notification.Name("ScoreGained"), object: accumulatedScoreGain)
        }
    }

    func moveUp() {
        grid = transpose(grid)
        moveLeft()
        grid = transpose(grid)
    }

    func moveDown() {
        grid = transpose(grid)
        moveRight()
        grid = transpose(grid)
    }
    
    private func transpose(_ matrix: [[Int]]) -> [[Int]] {
        let size = matrix.count
        var transposed = Array(repeating: Array(repeating: 0, count: size), count: size)

        for row in 0..<size {
            for col in 0..<size {
                transposed[row][col] = matrix[col][row]
            }
        }

        return transposed
    }
    
    private func mergeRow(_ row: [Int]) -> ([Int], Int) {
        var filtered = row.filter { $0 != 0 }
        var merged: [Int] = []
        var skip = false
        var scoreAdded = 0
        
        for i in 0..<filtered.count {
            if skip {
                skip = false
                continue
            }
            
            if i+1 < filtered.count && filtered[i] == filtered[i+1] {
                let newVal = filtered[i] * 2
                score += newVal
                scoreAdded += newVal
                merged.append(newVal)
                skip = true
            }
            else {
                merged.append(filtered[i])
            }
        }
        
        while merged.count < grid.count {
            merged.append(0)
        }
        
        return (merged, scoreAdded)
    }
    
    func spawnTile() {
        var emptyPos: [(Int, Int)] = []
        for row in 0..<grid.count {
            for col in 0..<grid.count {
                if grid[row][col] == 0 {
                    emptyPos.append((row, col))
                }
            }
        }
        
        if let (row, col) = emptyPos.randomElement() {
            grid[row][col] = 2
        }
    }
    
    func isGameOver() -> Bool {
        for row in 0..<grid.count {
            for col in 0..<grid.count {
                if grid[row][col] == 0 {
                    return false
                }
                if col < grid.count - 1 && grid[row][col] == grid[row][col + 1] {
                    return false
                }
                if row < grid.count - 1 && grid[row][col] == grid[row + 1][col] {
                    return false
                }
            }
        }
        return true 
    }
}
