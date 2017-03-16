//
//  CircularUpperTabsCellState.swift
//  CircularUpperTabs
//
//  Created by Leonardo Wistuba de França on 3/12/17.
//  Copyright © 2017 Leonardo. All rights reserved.
//

import UIKit

class CircularUpperTabsCellState: NSObject {
    var selectedBackgroundColor: UIColor?
    var unselectedBackgroundColor: UIColor?
    var text: String
    var unselectedFontColor: UIColor?
    var selectedFontColor: UIColor?
    var textFont: UIFont?

    var isSelected = false

    init(text: String) {
        self.text = text
    }

    func width() -> CGFloat {
        let nsstring = NSString(string: text)
        let maxSize = CGSize(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX))
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]

        let boundingRect = nsstring.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)

        return boundingRect.width + 20
    }
}
