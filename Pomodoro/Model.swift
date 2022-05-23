//
//  Model.swift
//  Pomodoro
//
//  Created by t h a . m a m e rozz on 21.05.2022.
//

import UIKit

extension ViewController {
    
// MARK: - Extra methods
    
    func secondConverter(_ seconds: Int) -> String {
            
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        
        let formattedString = formatter.string(from: TimeInterval(seconds))!
            
        return formattedString
    }
    
    func refreshButton() {
        
        button.isSelected = false
        button.isHighlighted = false
        
        self.timerLabel.text = self.secondConverter(Metric.workModeDuration)
        self.timerLabel.textColor = self.mainColor
        
        DispatchQueue.main.async {

            self.circleToggle.timerDuration = Metric.workModeDuration
            self.circleToggle.miniCircleView.layer.borderColor = self.mainColor.cgColor
            self.circleToggle.miniFilledCircleView.backgroundColor = self.mainColor
            
            self.circleToggle.stopAnimation()
            
            self.shapeLayer.strokeEnd = 1
            self.shapeLayer.removeAllAnimations()
            
            self.durationTimer = Metric.workModeDuration
        }
        
    }
    
    func choosenColor(value: Bool) -> UIColor {
        
        guard value else { return ViewController.Colors.restColor }
        return ViewController.Colors.workColor
        
    }
}


