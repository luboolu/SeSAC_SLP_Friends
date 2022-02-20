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
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.SeSacBackgroundTableViewCell.id) as? SeSacBackgroundTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
