//
//  SubButton.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/10.
//

import UIKit

@IBDesignable
class SubButton: UIButton {
    
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
    
    var status: SubButtonStatus = .accept {
        didSet {
            switch status {
            case .accept:
                self.backgroundColor = UIColor().success
                self.clipsToBounds = true
                self.cornerRadius = 8
                self.setTitle("수락하기", for: .normal)
                self.setTitleColor(UIColor().white, for: .normal)
                self.titleLabel?.font = UIFont().Title3_M14
            case .request:
                self.backgroundColor = UIColor().error
                self.clipsToBounds = true
                self.cornerRadius = 8
                self.setTitle("요청하기", for: .normal)
                self.setTitleColor(UIColor().white, for: .normal)
                self.titleLabel?.font = UIFont().Title3_M14
            }
        }
    }


    convenience init(status: SubButtonStatus) {
        self.init()
    }

}
