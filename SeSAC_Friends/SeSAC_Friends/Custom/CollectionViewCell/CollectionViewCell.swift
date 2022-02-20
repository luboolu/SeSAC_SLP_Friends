//
//  CollectionViewCell.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/29.
//

import Foundation

enum CollectionViewCell {
    
    case ButtonCollectionViewCell
    case SeSacCharacterCollectionViewCell
    case SeSacBackgroundCollectionViewCell
    
    var id: String {
        switch self {
        case .ButtonCollectionViewCell:
            return "ButtonCollectionViewCell"
        case .SeSacCharacterCollectionViewCell:
            return "SeSacCharacterCollectionViewCell"
        case .SeSacBackgroundCollectionViewCell:
            return "SeSacBackgroundCollectionViewCell"
        }
    }
    
}
