//
//  ReviewDetailViewController.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/02/14.
//

import UIKit

final class ReviewDetailViewController: UIViewController {
    
    private let mainView = ReviewDetailView()
    
    var reviews: [String]?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        print(reviews)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor().black
        self.navigationItem.title = "새싹 리뷰"
    }
    
    private func setTableView() {
        mainView.reviewTableView.delegate = self
        mainView.reviewTableView.dataSource = self
        
        mainView.reviewTableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: TableViewCell.TextViewTableViewCell.id)
    }
}

extension ReviewDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.TextViewTableViewCell.id) as? TextViewTableViewCell else { return UITableViewCell() }
        print("리뷰셀")
        //cell.backgroundColor = UIColor().focus
        cell.textView.text = "\(reviews?[indexPath.row] ?? "")"
        
        return cell
    }
}
