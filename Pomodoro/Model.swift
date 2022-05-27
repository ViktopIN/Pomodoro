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
        
        self.pauseButton.isSelected = false
        self.pauseButton.isHighlighted = false

        DispatchQueue.main.async {

            self.circleToggle.timerDuration = Metric.workModeDuration
            self.circleToggle.miniCircleView.layer.borderColor = self.mainColor.cgColor
            self.circleToggle.miniFilledCircleView.backgroundColor = self.mainColor
            
            self.circleToggle.stopAnimation()
            
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
        
    }
    
    func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        
        shapeLayer.speed = 1.0
        
        shapeLayer.timeOffset = 0
        
        shapeLayer.beginTime = 0
        
        let timeSincePaused = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        
        shapeLayer.beginTime = timeSincePaused
    }
}


