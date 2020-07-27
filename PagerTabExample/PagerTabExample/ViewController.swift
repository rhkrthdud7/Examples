//
//  ViewController.swift
//  PagerTabExample
//
//  Created by Soso on 2020/07/25.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class ViewController: UIViewController {

    enum Status: Int {
        case all = 0, opened, closed, scheduled
    }
    private enum Metric {
        static let topTabBarHeight: CGFloat = 44
        static let indicatorHeight: CGFloat = 4
        static let spacing: CGFloat = 20
    }

    let disposeBag = DisposeBag()

    let status = BehaviorRelay(value: Status.all)

    let viewSafeAreaTop = UIView().then {
        $0.backgroundColor = .clear
    }
    let viewNavigationBar = UIView().then {
        $0.backgroundColor = .white
    }
    lazy var pagerBar = PagerBar(subviews: buttons).then {
        $0.backgroundColor = .clear
    }
    let buttonAll = UIButton().then {
        $0.setTitle("전체", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
    }
    let buttonOpened = UIButton().then {
        $0.setTitle("진행중인 프리오더", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
    }
    let buttonClosed = UIButton().then {
        $0.setTitle("마감된 프리오더", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
    }
    let buttonScheduled = UIButton().then {
        $0.setTitle("예정인 프리오더", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
    }
    lazy var buttons = [buttonAll, buttonOpened, buttonClosed, buttonScheduled]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }

    func setupViews() {
        view.backgroundColor = .red

        view.addSubview(viewSafeAreaTop)
        viewSafeAreaTop.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        view.addSubview(viewNavigationBar)
        viewNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(viewSafeAreaTop)
            $0.bottom.equalTo(viewSafeAreaTop.snp.bottom).offset(58)
        }

        viewNavigationBar.addSubview(pagerBar)
        pagerBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(viewNavigationBar.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Metric.topTabBarHeight)
        }
    }

    func setupBindings() {
        let buttonTaps = Observable.of(
            buttonAll.rx.tap.map({ Status.all }),
            buttonOpened.rx.tap.map({ Status.opened }),
            buttonClosed.rx.tap.map({ Status.closed }),
            buttonScheduled.rx.tap.map({ Status.scheduled })
        ).merge().share()

        buttonTaps
            .bind(to: status)
            .disposed(by: disposeBag)

        status
            .distinctUntilChanged()
            .map({ $0.rawValue })
            .bind(to: pagerBar.rx.currentIndex)
            .disposed(by: disposeBag)
    }
}
