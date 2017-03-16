//
//  CircularUpperTabsView.swift
//  CircularUpperTabs
//
//  Created by Leonardo Wistuba de França on 3/11/17.
//  Copyright © 2017 Leonardo. All rights reserved.
//

import UIKit

protocol CircularUpperTabsViewDataSource: class {
    func getCellState() -> [CircularUpperTabsCellState]
}

class CircularUpperTabsView: UIView {
    let cellIdentifier = "CircularUpperTabsCell"
    weak var movingView: UIView?

    private weak var collectionView: UICollectionView!
    weak var dataSource: CircularUpperTabsViewDataSource? {
        didSet {
            reloadData()
        }
    }

    internal var cellStates: [CircularUpperTabsCellState] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        let flowLayout = SomeShit()
        flowLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast

        collectionView.register(CircularUpperTabsCell.self,
                                forCellWithReuseIdentifier: cellIdentifier)


        addCollectionViewAsSubview(collectionView: collectionView)

        self.collectionView = collectionView
    }

    private func addCollectionViewAsSubview(collectionView: UICollectionView) {
        addSubview(collectionView)

        let constraintsAttributes: [NSLayoutAttribute] = [.top, .leading, .trailing, .bottom]
        let constraints = constraintsAttributes.map { (layoutAttribute) -> NSLayoutConstraint in
            NSLayoutConstraint(item: collectionView, attribute: layoutAttribute, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: layoutAttribute, multiplier: 1.0, constant: 0.0)
        }

        addConstraints(constraints)
    }

    func reloadData() {
        guard let cellStates = dataSource?.getCellState() else {
            return
        }

        self.cellStates = cellStates

        collectionView.reloadData()
    }

    func fakeNeighborsRemovalOfCellAt(indexPath: IndexPath) -> [CircularUpperTabsCellContentView] {
        var neighbors: [CircularUpperTabsCell] = []

        guard let visibleCells = collectionView.visibleCells as? [CircularUpperTabsCell] else {
            return []
        }

        neighbors.append(contentsOf: visibleCells)

        var addedViews: [CircularUpperTabsCellContentView] = []

        neighbors.forEach { (cell) in
            let view = CircularUpperTabsCellContentView(frame: cell.frame)
            view.cellState = cell.cellState
            collectionView.addSubview(view)
            addedViews.append(view)
        }

        return addedViews

    }

}

extension CircularUpperTabsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cellsToRender: [CircularUpperTabsCell] = []

        for (index, state) in cellStates.enumerated() {
            if state.isSelected {
                let indexPath = IndexPath(item: index, section: 0)
                guard let cell = collectionView.cellForItem(at: indexPath) as? CircularUpperTabsCell else {
                    continue
                }
                cellsToRender.append(cell)
            }

            state.isSelected = false
        }

        let selectedCellState = cellStates[indexPath.item]
        selectedCellState.isSelected = true

        guard let cell = collectionView.cellForItem(at: indexPath) as? CircularUpperTabsCell else {
            return
        }

        cellsToRender.append(cell)

        var addedCells: [CircularUpperTabsCellContentView] = []
        let neighborAddedCells = self.fakeNeighborsRemovalOfCellAt(indexPath: indexPath)
        addedCells.append(contentsOf: neighborAddedCells)

        guard let visibleCells = collectionView.visibleCells as? [CircularUpperTabsCell] else {
            return
        }

        visibleCells.forEach { (cell) in
            cell.circularUpperTabsCellContentView?.alpha = 0.0
            cell.alpha = 0.0
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.movingView?.frame = cell.frame

            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)

            cellsToRender.forEach({ (cell) in
                cell.render()
            })

        }) { (finished) in
            addedCells.forEach({ (view) in
                view.removeFromSuperview()
            })

            visibleCells.forEach { (cell) in
                cell.circularUpperTabsCellContentView?.alpha = 1.0
                cell.alpha = 1.0
            }
        }
    }
}

extension CircularUpperTabsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellState = cellStates[indexPath.item]

        let size = CGSize(width: cellState.width(), height: frame.height - 10)
        return size
    }
}

extension CircularUpperTabsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        print("cellForItemAt: indexPath: \(indexPath)")


        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? CircularUpperTabsCell else {
            return UICollectionViewCell()
        }

        let cellState = cellStates[indexPath.item]

        if cellState.isSelected && movingView == nil {
            let size = CGSize(width: cellState.width(), height: frame.height - 10)
            let movingView = UIView(frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: size.width, height: size.height))

            movingView.backgroundColor = UIColor(colorLiteralRed: 125.0/255.0, green: 176.0/255.0, blue: 199.0/255.0, alpha: 1.0)
            movingView.layer.cornerRadius = 15
            movingView.alpha = 1.0

            collectionView.addSubview(movingView)
            movingView.alpha = 0.3

            self.movingView = movingView
        }


//        collectionView.sendSubview(toBack: movingView!)

        cell.cellState = cellState

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellStates.count
    }
}


class SomeShit: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}
