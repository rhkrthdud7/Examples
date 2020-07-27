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

    enum Status {
        case all, opened, closed, scheduled
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
    let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    lazy var stackView = UIStackView(arrangedSubviews: [buttonAll, buttonOpened, buttonClosed, buttonScheduled]).then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = Metric.spacing
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = .init(top: 0, leading: Metric.spacing, bottom: 0, trailing: Metric.spacing)
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
    let viewIndicator = UIView().then {
        $0.backgroundColor = .black
    }

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

        viewNavigationBar.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalTo(viewNavigationBar.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Metric.topTabBarHeight)
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        scrollView.addSubview(viewIndicator)

        // indicator 초기 위치 강제로 설정
        view.layoutIfNeeded()
        var frame = stackView.convert(buttonAll.frame, to: scrollView)
        frame.origin.y = Metric.topTabBarHeight - Metric.indicatorHeight
        frame.size.height = Metric.indicatorHeight
        viewIndicator.frame = frame
    }

    func setupBindings() {

        let scrollView = self.scrollView
        let stackView = self.stackView
        let buttonAll = self.buttonAll
        let buttonOpened = self.buttonOpened
        let buttonClosed = self.buttonClosed
        let buttonScheduled = self.buttonScheduled
        let viewIndicator = self.viewIndicator

        let tap = Observable.of(
            buttonAll.rx.tap.map({ _ in Status.all }),
            buttonOpened.rx.tap.map({ _ in Status.opened }),
            buttonClosed.rx.tap.map({ _ in Status.closed }),
            buttonScheduled.rx.tap.map({ _ in Status.scheduled })
        ).merge().share()

        tap
            .bind(to: status)
            .disposed(by: disposeBag)

        let tappedButton = status
            .distinctUntilChanged()
            .map({ status -> UIButton in
                switch status {
                case .all: return buttonAll
                case .opened: return buttonOpened
                case .closed: return buttonClosed
                case .scheduled: return buttonScheduled
                }
            })

        tappedButton
            .map({ $0.frame.insetBy(dx: -Metric.spacing, dy: 0) })
            .subscribe(onNext: { scrollView.scrollRectToVisible($0, animated: true) })
            .disposed(by: disposeBag)

        tappedButton
            .map({
                var frame = stackView.convert($0.frame, to: scrollView)
                frame.origin.y = Metric.topTabBarHeight - Metric.indicatorHeight
                frame.size.height = Metric.indicatorHeight
                return frame
            })
            .subscribe(onNext: { frame in
                UIView.animate(withDuration: 0.3) {
                    viewIndicator.frame = frame
                }
            })
            .disposed(by: disposeBag)

//        let taps = Observable.of(
//            buttonAll.rx.tap.map({ buttonAll }),
//            buttonOpened.rx.tap.map({ buttonOpened }),
//            buttonClosed.rx.tap.map({ buttonClosed }),
//            buttonScheduled.rx.tap.map({ buttonScheduled })
//        ).merge().distinctUntilChanged().share()
//
//        taps
//            .map({ $0.frame.insetBy(dx: -Metric.spacing, dy: 0) })
//            .do(onNext: { print("buttonFrame: \($0)") })
//            .subscribe(onNext: { scrollView.scrollRectToVisible($0, animated: true) })
//            .disposed(by: disposeBag)
//
//        taps
//            .map({
//                var frame = stackView.convert($0.frame, to: scrollView)
//                frame.origin.y = Metric.topTabBarHeight - Metric.indicatorHeight
//                frame.size.height = Metric.indicatorHeight
//                return frame
//            })
//            .do(onNext: { print("labelFrame: \($0)") })
//            .subscribe(onNext: { frame in
//                UIView.animate(withDuration: 0.3) {
//                    viewIndicator.frame = frame
//                }
//            })
//            .disposed(by: disposeBag)
    }
}
