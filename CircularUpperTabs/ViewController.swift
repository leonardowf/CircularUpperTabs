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

    override func viewDidLoad() {
        super.viewDidLoad()

        circularUpperTabsView.dataSource = self


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: CircularUpperTabsViewDataSource {
    func getCellState() -> [CircularUpperTabsCellState] {
        var states: [CircularUpperTabsCellState] = []

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

        return states
    }
}

