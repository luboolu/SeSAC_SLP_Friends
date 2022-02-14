//
//  Identifier.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/27.
//

import Foundation

enum TableViewCell {
    case ProfileTableViewCell
    case IconTableViewCell
    case TwoButtonTableViewCell
    case TextfieldTableViewCell
    case LabelTableViewCell
    case SwitchTableViewCell
    case DoubleSliderTableViewCell
    case CardTableViewCell
    case CharactorTableViewCell
    case TextViewTableViewCell
    
    var id: String {
        switch self {
        case .ProfileTableViewCell:
            return "ProfileTableViewCell"
        case .IconTableViewCell:
            return "IconTableViewCell"
        case .TwoButtonTableViewCell:
            return "TwoButtonTableViewCell"
        case .TextfieldTableViewCell:
            return "TextfieldTableViewCell"
        case .LabelTableViewCell:
            return "LabelTableViewCell"
        case .SwitchTableViewCell:
            return "SwitchTableViewCell"
        case .DoubleSliderTableViewCell:
            return "DoubleSliderTableViewCell"
        case .CardTableViewCell:
            return "CardTableViewCell"
        case .CharactorTableViewCell:
            return "CharactorTableViewCell"
        case .TextViewTableViewCell:
            return "TextViewTableViewCell"
        }
    }
}
