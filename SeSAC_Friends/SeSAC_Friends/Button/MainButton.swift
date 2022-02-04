//
//  MainButtonLarge.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/18.
//

import UIKit

@IBDesignable
class MainButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    var status: MainButtonStatus = .inactive {
        didSet {
            switch status {
            case .inactive:
                self.backgroundColor = UIColor().white
                self.clipsToBounds = true
                self.borderColor = UIColor().gray2
                self.borderWidth = 1
                self.setTitleColor(UIColor().black, for: .normal)
                //self.titleLabel?.font = UIFont().Body3_R14
                self.cornerRadius = 10
            case .fill:
                self.backgroundColor = UIColor().green
                self.clipsToBounds = true
                self.borderWidth = 0
                self.setTitleColor(UIColor().white, for: .normal)
                //self.titleLabel?.font = UIFont().Body3_R14
                self.cornerRadius = 10
            case .outline:
                self.backgroundColor = UIColor().white
                self.clipsToBounds = true
                self.borderColor = UIColor().green
                self.borderWidth = 1
                self.setTitleColor(UIColor().green, for: .normal)
                //self.titleLabel?.font = UIFont().Body3_R14
                self.cornerRadius = 10
            case .cancel:
                self.backgroundColor = UIColor().gray2
                self.clipsToBounds = true
                self.borderWidth = 0
                self.setTitleColor(UIColor().black, for: .normal)
                //self.titleLabel?.font = UIFont().Body3_R14
                self.cornerRadius = 10
            case .disable:
                self.backgroundColor = UIColor().gray6
                self.clipsToBounds = true
                self.borderWidth = 0
                self.setTitleColor(UIColor().white, for: .normal)
                //self.titleLabel?.font = UIFont().Body3_R14
                self.cornerRadius = 10
            case .focus:
                self.backgroundColor = UIColor().white
                self.clipsToBounds = true
                self.borderColor = UIColor().error
                self.borderWidth = 1
                self.setTitleColor(UIColor().error, for: .normal)
                //self.titleLabel?.font = UIFont().Body3_R14
                self.cornerRadius = 10
            }
        }
    }
    
    var imageStyle: MainButtonImageStyle = .none {
        didSet {
            switch imageStyle {
            case .close_color:
                self.setImage(UIImage(named: "close_color"), for: .normal)
                self.imageView?.contentMode = .scaleAspectFit
                self.semanticContentAttribute = .forceRightToLeft //<- 중요
                //cell.button.imageEdgeInsets = .init(top: 5, left: 20, bottom: 5, right: 16) //<- 중요
                
                self.contentHorizontalAlignment = .center

            case .none:
                self.setImage(UIImage(named: ""), for: .normal)
            }
        }
    }
    
    convenience init(status: MainButtonStatus) {
        self.init()
    }

}
