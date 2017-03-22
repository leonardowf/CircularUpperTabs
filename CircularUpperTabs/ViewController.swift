//
//  ViewController.swift
//  CircularUpperTabs
//
//  Created by Leonardo Wistuba de França on 3/11/17.
//  Copyright © 2017 Leonardo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var circularUpperTabsView: CircularUpperTabsView!
    var states: [CircularUpperTabsCellState] = []

    var selected: CircularUpperTabsCellState?

    override func viewDidLoad() {
        super.viewDidLoad()

        getCellState()

        circularUpperTabsView.dataSource = self


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didSelectNextButton(_ sender: UIButton) {
        guard let selected = selected, let index = states.index(of: selected) else {
            return
        }

        let next = states[index + 1]

        self.selected = next

        circularUpperTabsView.reloadData()

    }

    @IBAction func didSelectRemakeItemsButton(_ sender: UIButton) {
        states = []
        for index in 1...22 {
            let a = CircularUpperTabsCellState(text: "adssd \(index)")

            states.append(a)
        }
        states[1].text = "um texto bem grande"

        selected = states.first
        circularUpperTabsView.reloadData()
    }


}

extension ViewController: CircularUpperTabsViewDataSource {
    internal func getCellStatesFor(circularUpperTabsView: CircularUpperTabsView) -> [CircularUpperTabsCellState] {
        return states
    }

    func getCellState() -> [CircularUpperTabsCellState] {
        let unselectedColor = UIColor.white
        let selectedColor = UIColor.brown

        let selectedFontColor = UIColor.white
//        let unselectedFontColor = UIColor.brown

        let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)

        for index in 1...100 {
            let a = CircularUpperTabsCellState(text: "banana \(index)")
            a.selectedFontColor = selectedFontColor
//            a.unselectedFontColor = unselectedFontColor
            a.selectedBackgroundColor = selectedColor
            a.unselectedBackgroundColor = unselectedColor
            a.textFont = font

            states.append(a)
        }
        states[4].text = "um texto bem grande"
        states.first!.isSelected = true


        selected = states[0]

        return states
    }

    func selectedCellState() -> CircularUpperTabsCellState? {
        return selected
    }
}

