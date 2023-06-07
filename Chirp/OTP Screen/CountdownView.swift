//
//  CountdownView.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/6/23.
//

import UIKit

class CountdownView: UIView {
    
    private var countdownLabel = UILabel()
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    
    var startPoint: CGFloat = -.pi / 2
    var endPoint: CGFloat = .pi * 3/2
    
    var circleColor: UIColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
    var progressColor: UIColor = #colorLiteral(red: 0.337254902, green: 0.1921568627, blue: 0.1450980392, alpha: 1)
    
    var didFinishCountdown: (() -> Void)?

    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayers()
    }
    
    // UI
    private func setupUI() {
        countdownLabel.textAlignment = .center
        countdownLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countdownLabel)
        
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // Layers
    private func setupLayers() {
        let pathCenter = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let pathRadius = min(frame.width, frame.height) / 2
        
        let circularPath = UIBezierPath(arcCenter: pathCenter, radius: pathRadius,
                                        startAngle: startPoint, endAngle: endPoint,
                                        clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = circleColor.cgColor
        trackLayer.strokeEnd = 1.0
        trackLayer.lineWidth = 15
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.strokeEnd = 0.0
        progressLayer.lineWidth = 15
        layer.addSublayer(progressLayer)
    }
    
    // Animation
    func startCountdown(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.toValue = 1.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnimation")
        
        var countdownTime = Int(duration - 1)
        countdownLabel.text = "\(countdownTime)"
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard countdownTime > 0 else {
                timer.invalidate()
                self?.didFinishCountdown?()
                return
            }
            
            self?.countdownLabel.text = "\(countdownTime)"
            countdownTime -= 1
        }
    }
}
