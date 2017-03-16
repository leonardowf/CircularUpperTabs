//
//  CircularUpperTabsCellContentView.swift
//  CircularUpperTabs
//
//  Created by Leonardo Wistuba de França on 3/15/17.
//  Copyright © 2017 Leonardo. All rights reserved.
//

import UIKit

class CircularUpperTabsCellContentView: UIView {
    weak var label: UILabel!

    var cellState: CircularUpperTabsCellState? {
        didSet {
            render()
        }
    }

    deinit {
        print("CircularUpperTabsCellContentView is being released")
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
        print("alocando CircularUpperTabsCellContentView")

        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)

        addSubview(label)
        let constraintsAttributes: [NSLayoutAttribute] = [.top, .leading, .trailing, .bottom]
        let constraints = constraintsAttributes.map { (layoutAttribute) -> NSLayoutConstraint in
            NSLayoutConstraint(item: label, attribute: layoutAttribute, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: layoutAttribute, multiplier: 1.0, constant: 0.0)
        }

        addConstraints(constraints)

        layer.cornerRadius = 15
        
        self.label = label
    }

    func render() {
        guard let cellState = self.cellState else {
            return
        }

        guard let label = label else {
            print("label nula")
            return
        }

//        if cellState.isSelected {
//            label.alpha = 1.0
//        } else {
//            label.alpha = 0.3
//        }

        label.text = cellState.text

    }

}
