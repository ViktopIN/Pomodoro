//
//  ViewController.swift
//  Pomodoro
//
//  Created by t h a . m a m e rozz on 20.05.2022.
//

import UIKit

class ViewController: UIViewController {

// MARK: - Properties
    private lazy var isWorkTime = true
    
    private lazy var isStarted = false
    
    lazy var durationTimer = Metric.workModeDuration

    var mainColor: UIColor {
        choosenColor(value: isWorkTime)
    }
    
   lazy var circleToggle: AnimatableCircleView = {
        
        var mainViewsPoint = CGPoint(x: (view.frame.width / 2) - (Metric.toggleCircleSize.width / 2),
                                     y: (view.frame.height / 2) - (Metric.toggleCircleSize.height / 2))
        var mainCircle = AnimatableCircleView(frame: CGRect(origin: mainViewsPoint, size: Metric.toggleCircleSize),
                                              mainColor: mainColor,
                                              durationTimer: durationTimer)
        
        return mainCircle
        
    }()
    
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
                                    primaryAction: UIAction {  _ in self.circleToggle.startAnimating()
        if self.isStarted {
            
            self.isStarted.toggle()
            self.isWorkTime = true
            
            self.timer.invalidate()
            
            /// Model
            self.refreshButton()
            
       
        } else {
            
            self.tappedButton()
            self.basicAnimation()
            
            self.isStarted.toggle()
        }
    })
    
// MARK: - Methods
    
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
                button.isHighlighted.toggle()
                
                isWorkTime.toggle()
                isStarted.toggle()
                
                timerLabel.text = secondConverter(Metric.workModeDuration)
                durationTimer = Metric.workModeDuration
                
                DispatchQueue.main.async {
                    
                    self.circleToggle.timerDuration = Metric.workModeDuration
                    self.circleToggle.miniCircleView.layer.borderColor = self.mainColor.cgColor
                    self.circleToggle.miniFilledCircleView.backgroundColor = self.mainColor
                    
                    self.timerLabel.textColor = self.mainColor
                }
                

            } else {
                
                isStarted = true
                isWorkTime.toggle()
                
                button.isHighlighted.toggle()
                timerLabel.text = secondConverter(Metric.restModeDuration)
                durationTimer = Metric.restModeDuration
    
                DispatchQueue.main.async {
                    
                    self.circleToggle.timerDuration = Metric.restModeDuration
                    self.circleToggle.miniCircleView.layer.borderColor = self.mainColor.cgColor
                    self.circleToggle.miniFilledCircleView.backgroundColor = self.mainColor
                    self.circleToggle.startAnimating()
                    
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
        view.addSubview(circleToggle)
        view.addSubview(button)
        view.addSubview(timerLabel)
    }
    
    private func setupLayout() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Metric.buttonYOffset),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: Metric.buttonSize),
            button.heightAnchor.constraint(equalToConstant: Metric.buttonSize)
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
        
        let center = CGPoint(x: circleToggle.frame.width / 2, y: circleToggle.frame.height / 2)
        
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
        
        circleToggle.layer.addSublayer(shapeLayer)
         
    }
    
    func basicAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}

