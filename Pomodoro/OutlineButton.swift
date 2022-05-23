//
//  OutlineButton.swift
//  Pomodoro
//
//  Created by t h a . m a m e rozz on 21.05.2022.
//

import UIKit

class OutlineButton: UIButton {
    
    static var workColor: UIColor = .init(red: 254/255, green: 139/255, blue: 129/255, alpha: 1)
    static var restColor: UIColor = .init(red: 99/255, green: 197/255, blue: 165/255, alpha: 1)
    
    override func updateConfiguration() {
        switch self.state {
        case .normal:
            self.configuration?.baseBackgroundColor = .clear
            self.configuration?.background.image = UIImage(systemName: "play")?.withTintColor(OutlineButton.workColor, renderingMode: .alwaysOriginal)
        case .selected:
            self.configuration?.baseBackgroundColor = .clear
            self.configuration?.background.image = UIImage(systemName: "gobackward")?.withTintColor(OutlineButton.workColor, renderingMode: .alwaysOriginal)
        case .highlighted:
            self.configuration?.baseBackgroundColor = .clear
            self.configuration?.background.image = UIImage(systemName: "gobackward")?.withTintColor(OutlineButton.restColor, renderingMode: .alwaysOriginal)
            
        default:
            configuration?.baseBackgroundColor = .clear
            configuration?.background.image = UIImage(systemName: "play")?.withTintColor(OutlineButton.workColor, renderingMode: .alwaysOriginal)
        }
    }
}
