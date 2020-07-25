//
//  ViewController.swift
//  ActivityIndicatorExample
//
//  Created by Soso on 2020/07/25.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let refreshControl = UIRefreshControl()

    let data: [UIColor] = [.red, .yellow, .orange, .purple, .blue, .green]

    let disposeBag = DisposeBag()

    let isRefreshing = PublishRelay<Bool>()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }

    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.refreshControl = refreshControl
    }

    func setupBindings() {
        let refreshControl = self.refreshControl
        let tableView = self.tableView!

        refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .filter({ refreshControl.isRefreshing })
            .map({ _ in true })
            .drive(onNext: isRefreshing.accept)
            .disposed(by: disposeBag)

        tableView.rx.didEndDragging
            .withLatestFrom(isRefreshing)
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: isRefreshing.accept)
            .disposed(by: disposeBag)

        isRefreshing
            .asDriver(onErrorJustReturn: false)
            .filter({ $0 || !tableView.isDragging })
            .distinctUntilChanged()
            .debug()
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        isRefreshing
            .asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
            .filter({ $0 })
            .delay(.seconds(2))
            .map({ !$0 })
            .drive(onNext: isRefreshing.accept)
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.backgroundColor = data[indexPath.row]
        return cell
    }
}
