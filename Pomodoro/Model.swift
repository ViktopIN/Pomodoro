//
//  Model.swift
//  Pomodoro
//
//  Created by t h a . m a m e rozz on 21.05.2022.
//

import UIKit

extension ViewController {
    
// MARK: - Extra methods
    
    func toTextFormatConverter(_ miliseconds: Int) -> String {
        var seconds = Int()
        if miliseconds % 100 == 0 {
            seconds = miliseconds / 100
        } else {
        
            seconds = miliseconds / 100 + 1
        }

        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        
        let formattedString = formatter.string(from: TimeInterval(seconds))!
            
        return formattedString
    }
    
    func refreshButton() {
        
        button.isSelected = false
        button.isHighlighted = false
        
        self.timerLabel.text = self.toTextFormatConverter(Metric.workModeDuration)
        self.timerLabel.textColor = self.mainColor
        
        self.pauseButton.isSelected = false
        self.pauseButton.isHighlighted = false

        DispatchQueue.main.async {
            
            self.shapeLayer.strokeEnd = 0
            self.shapeLayer.removeAllAnimations()
            
            self.durationTimer = Metric.workModeDuration
        }
        
    }
    
    func choosenColor(value: Bool) -> UIColor {
        
        guard value else { return ViewController.Colors.restColor }
        return ViewController.Colors.workColor
        
    }
    
    func pauseAnimation() {
        
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        
        shapeLayer.speed = 0

        shapeLayer.timeOffset = pausedTime
        print(pausedTime)
        
    }
    
    func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        print(pausedTime)
        
        shapeLayer.speed = 1.0
        shapeLayer.beginTime = 0
        shapeLayer.timeOffset = 0
                
        let timeSincePaused = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        print(timeSincePaused)
        shapeLayer.beginTime = timeSincePaused
    }
}


