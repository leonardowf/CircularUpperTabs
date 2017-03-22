//
//  CircularUpperTabsView.swift
//  CircularUpperTabs
//
//  Created by Leonardo Wistuba de França on 3/11/17.
//  Copyright © 2017 Leonardo. All rights reserved.
//

import UIKit

protocol CircularUpperTabsViewDataSource: class {
    func getCellStatesFor(circularUpperTabsView: CircularUpperTabsView) -> [CircularUpperTabsCellState]
    func selectedCellState() -> CircularUpperTabsCellState?
}

class CircularUpperTabsView: UIView {
    fileprivate struct CellAndAnimationOverlayView {
        let cell: CircularUpperTabsCell
        let animationOverlayView: CircularUpperTabsCellContentView
    }

    fileprivate let cellIdentifier = "CircularUpperTabsCell"
    fileprivate weak var movingView: UIView?
    fileprivate weak var collectionView: UICollectionView!
    fileprivate var selectedCellState: CircularUpperTabsCellState?
    weak var dataSource: CircularUpperTabsViewDataSource? {
        didSet {
            reloadData()
        }
    }

    fileprivate var cellStates: [CircularUpperTabsCellState] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        let flowLayout = UICollectionViewFlowLayout()
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
            NSLayoutConstraint(item: collectionView,
                               attribute: layoutAttribute,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: self,
                               attribute: layoutAttribute,
                               multiplier: 1.0,
                               constant: 0.0)
        }

        addConstraints(constraints)
    }

    func reloadData() {
        guard let cellStates = dataSource?.getCellStatesFor(circularUpperTabsView: self) else {
            return
        }

        selectedCellState = dataSource?.selectedCellState()

        self.cellStates = cellStates
        
        self.collectionView.reloadData()
        collectionView.performBatchUpdates({
//
        }) { (finished) in
            self.scrollToSelectedCellState()
        }
    }

    fileprivate func scrollToSelectedCellState() {
        guard let selectedCellState = self.selectedCellState else {
            return
        }

        guard let index = cellStates.index(of: selectedCellState) else {
            return
        }

        let indexPath = IndexPath(item: index, section: 0)

        if movingView == nil {
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        } else {
            xxx(indexPath: indexPath)
        }

    }

    fileprivate func xxx(indexPath: IndexPath, animated: Bool = true) {
        guard let cell = collectionView?.cellForItem(at: indexPath) else {
            yyy(indexPath: indexPath)
            return
        }

        let cellAndAnimationOverlayViewsAdded = addAnimationOverlayViewFor(indexPath: indexPath)
        hideCellsWithOverlayView(cellAndAnimationOverlayViews: cellAndAnimationOverlayViewsAdded)

        UIView.animate(withDuration: 0.3, animations: {
            self.movingView?.frame = cell.frame
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }) { (finished) in
            self.removeOverlayViewsShowingCells(cellAndAnimationOverlayViews: cellAndAnimationOverlayViewsAdded)
        }
    }

    fileprivate func yyy(indexPath: IndexPath) {

        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }) { (finished) in
            if let cell = self.collectionView?.cellForItem(at: indexPath) {
                self.movingView?.frame = cell.frame
            }


        }






    }

    fileprivate func addAnimationOverlayViewFor(indexPath: IndexPath) -> [CellAndAnimationOverlayView] {
        var neighbors: [CircularUpperTabsCell] = []

        guard let visibleCells = collectionView.visibleCells as? [CircularUpperTabsCell] else {
            return []
        }

        neighbors.append(contentsOf: visibleCells)

        var addedViews: [CellAndAnimationOverlayView] = []

        neighbors = neighbors.filter { (cell) -> Bool in
            guard let neighborIndexPath = collectionView.indexPath(for: cell) else {
                return true
            }
            return indexPath.item != neighborIndexPath.item
        }

        neighbors.forEach { (cell) in
            let view = CircularUpperTabsCellContentView(frame: cell.frame)
            view.cellState = cell.cellState
            collectionView.addSubview(view)
            let cellAndFakeView = CellAndAnimationOverlayView(cell: cell, animationOverlayView: view)

            addedViews.append(cellAndFakeView)
        }

        return addedViews
    }

    fileprivate func hideCellsWithOverlayView(cellAndAnimationOverlayViews: [CellAndAnimationOverlayView]) {
        cellAndAnimationOverlayViews.forEach({ (cellAndAnimationOverlayView) in
            cellAndAnimationOverlayView.cell.isHidden = true
        })
    }

    fileprivate func removeOverlayViewsShowingCells(cellAndAnimationOverlayViews: [CellAndAnimationOverlayView]) {
        cellAndAnimationOverlayViews.forEach { (cellAndAnimationOverlayView) in
            cellAndAnimationOverlayView.animationOverlayView.removeFromSuperview()
            cellAndAnimationOverlayView.cell.isHidden = false
        }
    }
}

extension CircularUpperTabsView: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var cellsToRender: [CircularUpperTabsCell] = []

        guard let cell = collectionView.cellForItem(at: indexPath) as? CircularUpperTabsCell else {
            return
        }

        xxx(indexPath: indexPath)
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

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? CircularUpperTabsCell else {
            return UICollectionViewCell()
        }

        let cellState = cellStates[indexPath.item]

        if cellState == selectedCellState && movingView == nil {
            let size = CGSize(width: cellState.width(), height: frame.height - 10)
            let movingView = UIView(frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: size.width, height: size.height))

            movingView.backgroundColor = UIColor(colorLiteralRed: 125.0/255.0, green: 176.0/255.0, blue: 199.0/255.0, alpha: 1.0)
            movingView.layer.cornerRadius = 15
            movingView.alpha = 1.0

            collectionView.addSubview(movingView)
            movingView.alpha = 1.0

            self.movingView = movingView
        }

        if let movingView = movingView {
            collectionView.sendSubview(toBack: movingView)
        }


        cell.cellState = cellState

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellStates.count
    }
}
