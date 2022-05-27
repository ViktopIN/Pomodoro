//
//  ColorPreferences.swift
//  Pomodoro
//
//  Created by t h a . m a m e rozz on 21.05.2022.
//

import UIKit

// MARK: - Colors
extension ViewController {
    
    enum Colors {
        static var restColor: UIColor = .init(red: 99/255, green: 197/255, blue: 165/255, alpha: 1)
        static var workColor: UIColor = .init(red: 254/255, green: 139/255, blue: 129/255, alpha: 1)
    }
}

// MARK: - Metrics
extension ViewController {
    enum Metric {
        static var workModeDuration = 8
        static var restModeDuration = 5
        
        static var timerLabelFontSize: CGFloat = 75
        static var timerLabelYOffset: CGFloat = -50
        
        static var toggleCircleSize = CGSize(width: 300, height: 300)
        
        static var buttonSize: CGFloat = 45
        static var buttonYOffset: CGFloat = 90
        
        static var animatedPathRadius: CGFloat = 150
        static var animatedPathLineWidth: CGFloat = 5

    }
}
