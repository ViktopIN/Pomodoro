//
//  ViewController.swift
//  Pomodoro
//
//  Created by t h a . m a m e rozz on 20.05.2022.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

// MARK: - Properties
    private lazy var isWorkTime = true
    
    private lazy var isStarted = false
    
    private lazy var isGobackward = false
    
    lazy var durationTimer = Metric.workModeDuration

    var mainColor: UIColor {
        choosenColor(value: isWorkTime)
    }
    
    
     lazy var timerLabel: UILabel = {
         
        var label = UILabel()
         
        label.text = secondConverter(durationTimer)
        label.font = UIFont.systemFont(ofSize: Metric.timerLabelFontSize)
        label.textColor = mainColor
         
        return label
    }()
   
    /// Конфигурация(внешний вид) кнопки
    lazy var configuration: OutlineButton.Configuration = {
        var configuration = OutlineButton.Configuration.plain()
    
        return configuration
    }()
 
    /// Объявление основной кнопки с ее механизмом
    lazy var button = OutlineButton(configuration: configuration,
                                    primaryAction: UIAction { _ in self.shapeLayer
        if self.isStarted || self.isGobackward == true {
            
            self.isStarted = false
            self.isWorkTime = true
            
            self.isGobackward = false
            
            self.timer.invalidate()
                        
            /// Model
            self.resumeAnimation()
            self.refreshButton()
            
            self.pauseButton.isHidden = true
       
        } else {
            
            self.tappedButton()
            self.basicAnimation()
            
            self.pauseButton.isHidden = false

            self.isStarted.toggle()
            self.isGobackward = true
        }
    })
    
    lazy var pauseButton: UIButton = {
        var button = UIButton()
                
        button.setBackgroundImage(UIImage(systemName: "pause")?.withTintColor(Colors.workColor, renderingMode: .alwaysOriginal), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "pause")?.withTintColor(Colors.restColor, renderingMode: .alwaysOriginal), for: .highlighted)
        button.setBackgroundImage(UIImage(systemName: "play")?.withTintColor(Colors.workColor, renderingMode: .alwaysOriginal), for: .selected)

        button.isHidden = true
        
        button.addTarget(self, action: #selector(pausedTimer), for: .touchUpInside)
        
        return button
    }()
    
// MARK: - Methods
    
    @objc func pausedTimer() {
        
        if isWorkTime {
    
            pauseButton.setBackgroundImage(UIImage(systemName: "play")?.withTintColor(Colors.workColor, renderingMode: .alwaysOriginal), for: .selected)
        } else {

            pauseButton.setBackgroundImage(UIImage(systemName: "play")?.withTintColor(Colors.restColor, renderingMode: .alwaysOriginal), for: .selected)
        }
        
        if !isStarted {
            
            resumeAnimation()
            
            tappedButton()
            button.isSelected.toggle()
            
            isStarted = true
            print("\(isWorkTime)")
            
            if !isWorkTime {
                DispatchQueue.main.async {
                    
                    self.pauseButton.isHighlighted = true

                }
            }
            
            pauseButton.isSelected = false
            
        } else {
        
            pauseAnimation()
            
            timer.invalidate()
            
            isStarted = false
            
            pauseButton.isSelected = true
            pauseButton.isHighlighted = false

        }
    }
    
    var timer = Timer()

    private func tappedButton() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        button.isSelected.toggle()
      
    }

    @objc func timerAction() {
        durationTimer -= 1
        
        timerLabel.text = secondConverter(durationTimer)
        
        if durationTimer == 0 {
            
            timer.invalidate()
            
            if isWorkTime == false {
                
                isGobackward = false
                
                pauseButton.isHidden = true
                pauseButton.isHighlighted = false
                
                button.isHighlighted.toggle()
                button.isSelected = false
                
                isWorkTime.toggle()
                isStarted.toggle()
                
                timerLabel.text = secondConverter(Metric.workModeDuration)
                durationTimer = Metric.workModeDuration
                
                DispatchQueue.main.async {
                                        
                    self.timerLabel.textColor = self.mainColor
                }
                

            } else {
                
                
                pauseButton.isHighlighted = true
                
                isStarted = true
                isWorkTime = false
                
                button.isHighlighted = true
                
                timerLabel.text = secondConverter(Metric.restModeDuration)
                durationTimer = Metric.restModeDuration
    
                DispatchQueue.main.async {
                                        
                    self.tappedButton()
                    self.basicAnimation()
                    
                    self.timerLabel.textColor = self.mainColor
                
                }
            }
        }
    }
    
    
// MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
// MARK: - Settings
    private func setupHierarchy() {
        view.addSubview(button)
        view.addSubview(pauseButton)
        view.addSubview(timerLabel)
        view.layer.addSublayer(shapeLayer)
    }
    
    private func setupLayout() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Metric.buttonYOffset),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: Metric.buttonSize),
            button.heightAnchor.constraint(equalToConstant: Metric.buttonSize)
        ])
        
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Metric.buttonYOffset - Metric.buttonSize * 1.5),
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.widthAnchor.constraint(equalToConstant: Metric.buttonSize),
            pauseButton.heightAnchor.constraint(equalToConstant: Metric.buttonSize)
        ])
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Metric.timerLabelYOffset),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    private func setupView() {
        view.backgroundColor = .init(named: "backgroundColor")
    }
    
// MARK: - Animation
    let shapeLayer = CAShapeLayer()
    
    func animationCircular() {
        
        let center = view.center
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: Metric.animatedPathRadius,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise:  false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = Metric.animatedPathLineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = mainColor.cgColor
         
    }
    
    func basicAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        basicAnimation.delegate = self
        
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
}

