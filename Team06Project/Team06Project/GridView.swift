//  Nihal Shetty (ndshetty)
//  Isha Ghaisas (ighaisas)
//  App Name: Team06Project (2048Game)
//  GitHub Submission Date: 05/06/2025
//
//  GridView.swift
//  Team06Project
//
//  Created by Nihal Shetty on 4/27/25.
//

import UIKit

class GridView: UIView {

//    var grid: [[Int]] = [
//        [2, 4, 8, 2],
//        [8, 2, 4, 8],
//        [4, 8, 2, 4],
//        [2, 4, 8, 2]
//    ]
    
    var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).setFill()
        context.fill(rect)

        let gridSize = grid.count
        let padding: CGFloat = 8

        let totalPadding = padding * CGFloat(gridSize + 1)
        let tileSide = (min(rect.width, rect.height) - totalPadding) / CGFloat(gridSize)

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let value = grid[row][col]

                let x = padding + CGFloat(col) * (tileSide + padding)
                let y = padding + CGFloat(row) * (tileSide + padding)
                let tileRect = CGRect(x: x, y: y, width: tileSide, height: tileSide)

                let path = UIBezierPath(rect: tileRect)

                if value == 0 {
                    UIColor(white: 0.8, alpha: 1).setFill()
                } else {
                    tileColor(for: value).setFill()
                }

                path.fill()

                if value != 0 {
                    drawCenteredText("\(value)", in: tileRect, tileSide: tileSide)
                }
            }
        }
    }
    
    private func tileColor(for value: Int) -> UIColor {
        let theme = ThemeManager.shared.currentTheme

        switch theme {
        case .green:
            switch value {
            case 2: return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            case 4: return UIColor(red: 230/255, green: 255/255, blue: 230/255, alpha: 1)
            case 8: return UIColor(red: 200/255, green: 255/255, blue: 200/255, alpha: 1)
            case 16: return UIColor(red: 170/255, green: 255/255, blue: 170/255, alpha: 1)
            case 32: return UIColor(red: 140/255, green: 255/255, blue: 140/255, alpha: 1)
            case 64: return UIColor(red: 110/255, green: 220/255, blue: 110/255, alpha: 1)
            case 128: return UIColor(red: 80/255, green: 190/255, blue: 80/255, alpha: 1)
            case 256: return UIColor(red: 50/255, green: 160/255, blue: 50/255, alpha: 1)
            case 512: return UIColor(red: 30/255, green: 130/255, blue: 30/255, alpha: 1)
            case 1024: return UIColor(red: 20/255, green: 100/255, blue: 20/255, alpha: 1)
            case 2048: return UIColor(red: 0/255, green: 70/255, blue: 0/255, alpha: 1)
            default: return UIColor.black
            }
            
        case .blue:
            switch value {
            case 2: return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            case 4: return UIColor(red: 230/255, green: 230/255, blue: 255/255, alpha: 1)
            case 8: return UIColor(red: 200/255, green: 200/255, blue: 255/255, alpha: 1)
            case 16: return UIColor(red: 170/255, green: 170/255, blue: 255/255, alpha: 1)
            case 32: return UIColor(red: 140/255, green: 140/255, blue: 255/255, alpha: 1)
            case 64: return UIColor(red: 110/255, green: 110/255, blue: 255/255, alpha: 1)
            case 128: return UIColor(red: 80/255, green: 80/255, blue: 220/255, alpha: 1)
            case 256: return UIColor(red: 50/255, green: 50/255, blue: 190/255, alpha: 1)
            case 512: return UIColor(red: 30/255, green: 30/255, blue: 160/255, alpha: 1)
            case 1024: return UIColor(red: 20/255, green: 20/255, blue: 130/255, alpha: 1)
            case 2048: return UIColor(red: 0/255, green: 0/255, blue: 100/255, alpha: 1)
            default: return UIColor.black
            }
        }
    }

    private func drawCenteredText(_ text: String, in rect: CGRect, tileSide: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let fontSize = tileSide * 0.4
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: fontSize),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]

        let attributedString = NSAttributedString(string: text, attributes: attributes)

        let size = attributedString.size()
        let rect = CGRect(
            x: rect.origin.x + (rect.width - size.width) / 2,
            y: rect.origin.y + (rect.height - size.height) / 2,
            width: size.width,
            height: size.height
        )

        attributedString.draw(in: rect)
    }
}
