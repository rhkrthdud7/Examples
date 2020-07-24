//
//  ViewController.swift
//  CarouselExample
//
//  Created by Soso on 2020/07/16.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let layout = CarouselLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        view.contentInsetAdjustmentBehavior = .never
        view.isPagingEnabled = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
        let text = "row: \(indexPath.row)\n"
        cell.label.text = [String](repeating: text, count: 20).joined()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let offset = contentOffsetY / scrollView.bounds.height

        guard offset >= 0 else { return }
        let item = Int(offset)

        let indexPath = IndexPath(item: item, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCell else { return }
        let alpha = (offset - floor(offset))
        cell.effectView.alpha = min(alpha * 2, 0.9)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class CustomCell: UICollectionViewCell {
    let label = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark)).then {
        $0.alpha = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(effectView)
        effectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        effectView.alpha = 0
    }
}

class CarouselLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        itemSize = collectionView.bounds.size
        scrollDirection = .vertical
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        return attributes
            .compactMap({ $0.copy() as? UICollectionViewLayoutAttributes })
            .compactMap({ [weak self] in self?.transformLayoutAttributes($0) })
    }

    private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }

        let distance = collectionView.frame.height
        let offset = attributes.center.y - collectionView.contentOffset.y
        let position = offset / distance - 0.5

        let contentOffsetY = collectionView.contentOffset.y
        let originY = attributes.frame.origin.y
        let y = (contentOffsetY - originY) / 2

        let transform: CGAffineTransform
        if position < 0 {
            transform = CGAffineTransform(translationX: 0, y: y)
        } else {
            transform = .identity
        }
        attributes.transform = transform
        attributes.zIndex = attributes.indexPath.row

        return attributes
    }
}
