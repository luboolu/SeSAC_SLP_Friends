//
//  BackgroundShopViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/20.
//

import UIKit

import RxCocoa
import RxSwift

final class BackgroundShopViewController: UIViewController {
    
    private let mainView = BackgroundShopView()
    private let backgroundImage = ["sesac_background_1", "sesac_background_2", "sesac_background_3", "sesac_background_4", "sesac_background_5", "sesac_background_6", "sesac_background_7", "sesac_background_8"]
    private let backgroundImageName = ["하늘 공원", "씨티 뷰", "밤의 산책로", "낮의 산책로", "연극 무대", "라틴 거실", "홈트방", "뮤지션 작업실"]
    private let backgroundImageDescription = ["새싹들을 많이 마주치는 매력적인 하늘 공원입니다", "창밖으로 보이는 도시 야경이 아름다운 공간입니다", "어둡지만 무섭지 않은 조용한 산책로입니다", "즐겁고 가볍게 걸을 수 있는 산책로입니다", "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다", "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다", "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다", "여러가지 음악 작업을 할 수 있는 작업실입니다"]
    private let backgroundImagePrice = ["1,200", "1,200", "1,200", "1,200", "2,500", "2,500", "2,500", "2,500"]
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.backgroundTableView.delegate = self
        mainView.backgroundTableView.dataSource = self
        mainView.backgroundTableView.register(SeSacBackgroundTableViewCell.self, forCellReuseIdentifier: TableViewCell.SeSacBackgroundTableViewCell.id)
    }
}

extension BackgroundShopViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backgroundImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.SeSacBackgroundTableViewCell.id) as? SeSacBackgroundTableViewCell else { return UITableViewCell() }
        
        cell.backgroundImage.image = UIImage(named: backgroundImage[indexPath.row])
        cell.backgroundName.text = backgroundImageName[indexPath.row]
        cell.descriptionLabel.text = backgroundImageDescription[indexPath.row]
        cell.priceLabel.text = backgroundImagePrice[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
