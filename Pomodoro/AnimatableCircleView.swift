//
//  AnimatableCircleView.swift
//  Pomodoro
//
//  Created by t h a . m a m e rozz on 20.05.2022.
//

import UIKit

class AnimatableCircleView: UIView {
    
// MARK: - Initializators
    init(frame: CGRect ,mainColor: UIColor, durationTimer: Int) {
        self.mainColor = mainColor
        self.timerDuration = durationTimer
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Неинициализированные свойства
    var timerDuration: Int

    var mainColor: UIColor
    
// MARK: - Settings
    
    private func setup() {
        self.clipsToBounds = false

        self.addSubview(self.circleView)
        NSLayoutConstraint.activate([
            self.circleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.circleView.topAnchor.constraint(equalTo: self.topAnchor),
            self.circleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        miniCircleView.addSubview(miniFilledCircleView)
        NSLayoutConstraint.activate([
            miniFilledCircleView.centerYAnchor.constraint(equalTo: miniCircleView.centerYAnchor),
            miniFilledCircleView.centerXAnchor.constraint(equalTo: miniCircleView.centerXAnchor),
            miniFilledCircleView.widthAnchor.constraint(equalToConstant: Metric.insidePointSize),
            miniFilledCircleView.heightAnchor.constraint(equalToConstant: Metric.insidePointSize)
        ])
        
        self.addSubview(self.miniCircleView)
        NSLayoutConstraint.activate([
            self.miniCircleView.widthAnchor.constraint(equalToConstant: Metric.pointSize),
            self.miniCircleView.heightAnchor.constraint(equalToConstant: Metric.pointSize)
        ])
        
    }
// MARK: - Views
    private lazy var circleView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()

    lazy var miniCircleView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.layer.borderColor = mainColor.cgColor
        
        return view
    }()
    
    lazy var miniFilledCircleView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = mainColor
        
        view.layer.cornerRadius = Metric.insidePointSize / 2
        
        return view
    }()
 // MARK: - Layoutsetup
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.circleView.layer.cornerRadius = self.circleView.frame.width / 2.0
        self.miniCircleView.layer.cornerRadius = self.miniCircleView.frame.width / 2.0
        self.miniCircleView.center = self.getPoint(for: -90)
        
    }
    
// MARK: - Animation
    private func getPoint(for angle: Int) -> CGPoint {
    
      let radius = Double(self.circleView.layer.cornerRadius)

      let radian = Double(angle) * Double.pi / Double(180)

      let newCenterX = radius + radius * cos(radian)
      let newCenterY = radius + radius * sin(radian)

      return CGPoint(x: newCenterX, y: newCenterY)
    }
    
    func startAnimating() {
        let path = UIBezierPath()

        let initialPoint = self.getPoint(for: -90)
        path.move(to: initialPoint)

        for angle in -89...0 { path.addLine(to: self.getPoint(for: angle)) }
        for angle in 1...270 { path.addLine(to: self.getPoint(for: angle)) }

        path.close()

        self.animate(view: self.miniCircleView, path: path)
    }
    
    func animate(view: UIView, path: UIBezierPath) {
        
        let animation = CAKeyframeAnimation(keyPath: "position")

        animation.path = path.cgPath

        animation.repeatCount = 1
        animation.duration = CFTimeInterval(timerDuration)

        view.layer.add(animation, forKey: "animation")
    }
    
    func stopAnimation() {
        
        let path = UIBezierPath()
        
        let endPoint = self.getPoint(for: -90)
        path.move(to: endPoint)
        path.close()

        self.animateForStop(view: self.miniCircleView, path: path)
        
    }
    
    func animateForStop(view: UIView, path: UIBezierPath) {
        
        let animation = CAKeyframeAnimation(keyPath: "position")

        animation.path = path.cgPath
        
        view.layer.add(animation, forKey: "animation")
    }
    
// MARK: - Local metrics
    
    enum Metric {
        static var pointSize: CGFloat = 30
        static var insidePointSize: CGFloat = 14
    }
}

