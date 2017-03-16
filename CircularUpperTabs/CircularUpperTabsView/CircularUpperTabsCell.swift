//
//  CircularUpperTabsCell.swift
//  CircularUpperTabs
//
//  Created by Leonardo Wistuba de França on 3/11/17.
//  Copyright © 2017 Leonardo. All rights reserved.
//

import UIKit

class CircularUpperTabsCell: UICollectionViewCell {
    weak var circularUpperTabsCellContentView: CircularUpperTabsCellContentView?

    var cellState: CircularUpperTabsCellState? {
        didSet {
            render()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        let view = CircularUpperTabsCellContentView(frame: frame)

        view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(view)
        let constraintsAttributes: [NSLayoutAttribute] = [.top, .leading, .trailing, .bottom]
        let constraints = constraintsAttributes.map { (layoutAttribute) -> NSLayoutConstraint in
            NSLayoutConstraint(item: view, attribute: layoutAttribute, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: layoutAttribute, multiplier: 1.0, constant: 0.0)
        }

        addConstraints(constraints)
        
        self.circularUpperTabsCellContentView = view
    }

    func render() {
        circularUpperTabsCellContentView?.cellState = self.cellState
    }

}
