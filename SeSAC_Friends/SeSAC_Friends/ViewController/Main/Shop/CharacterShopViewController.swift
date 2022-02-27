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
    private let viewModel = UserViewModel()
    private let disposeBag = DisposeBag()
    
    private let characterImage = ["sesac_face_1", "sesac_face_2", "sesac_face_3", "sesac_face_4", "sesac_face_5"]
    private let characterName = ["기본 새싹", "튼튼 새싹", "민트 새싹", "퍼플 새싹", "골드 새싹"]
    private let characterDescription = ["새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함꼐 하는 것을 좋아합니다.", "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다.", "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다.", "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다.", "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."]
    private let characterPrice = ["1,200", "1,200", "2,500", "2,500", "2,500"]
    
    var purchasedList = [0]
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.characterCollectionView.delegate = self
        mainView.characterCollectionView.dataSource = self
        mainView.characterCollectionView.register(SeSacCharacterCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.SeSacCharacterCollectionViewCell.id)
        
        UserDefaults.standard.rx
            .observe(Int.self, UserdefaultKey.sesacCollection.rawValue)
            .subscribe(onNext: { newValue in
                DispatchQueue.main.async {
                    self.mainView.characterCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }

}

extension CharacterShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.SeSacCharacterCollectionViewCell.id, for: indexPath) as? SeSacCharacterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.characterImage.image = UIImage(named: characterImage[indexPath.row])
        cell.characterName.text = characterName[indexPath.row]
        cell.descriptionLabel.text = characterDescription[indexPath.row]
        
        if let characterCollection = UserDefaults.standard.object(forKey: UserdefaultKey.sesacCollection.rawValue) as? [Int] {
            if characterCollection.contains(indexPath.row) {
                cell.priceButton.status = .disable
                cell.priceButton.setTitle("보유중", for: .normal)
            } else {
                cell.priceButton.status = .fill
                cell.priceButton.setTitle(characterPrice[indexPath.row], for: .normal)
            }
        }
        
        cell.priceButton.rx.tap
            .bind {
                let popUp = PurchasePopUpViewController()
                popUp.mainTitle = "해당 아이템을 구매하시겠습니까?"
                popUp.subTitle = "아이템으로 나만의 새싹을 꾸밀 수 있어요"
                popUp.characterItem = indexPath.row
                popUp.modalPresentationStyle = .overCurrentContext
                popUp.modalTransitionStyle = .crossDissolve
                self.present(popUp, animated: true, completion: nil)
            }.disposed(by: cell.bag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        UserDefaults.standard.set(indexPath.row, forKey: UserdefaultKey.shopCharacter.rawValue)
        
    }
    
    
}
