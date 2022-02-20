//
//  CharacterShopViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/20.
//

import UIKit

import RxCocoa
import RxSwift

final class CharacterShopViewController: UIViewController {
    
    private let mainView = CharacterShopView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.characterCollectionView.delegate = self
        mainView.characterCollectionView.dataSource = self
        mainView.characterCollectionView.register(SeSacCharacterCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.SeSacCharacterCollectionViewCell.id)
    }
}

extension CharacterShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.SeSacCharacterCollectionViewCell.id, for: indexPath) as? SeSacCharacterCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}
