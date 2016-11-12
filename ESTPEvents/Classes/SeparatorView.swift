//
//  SeparatorView.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

enum SeparatorType {
    case top
    case bottom
}

private struct Constant {
    static let separatorHeight: CGFloat = 0.5
}

class SeparatorView: UIView {

    var separatorType: SeparatorType = .top {
        didSet {
            setNeedsDisplay()
        }
    }

    var color: UIColor = .grayColor() {
        didSet {
            setNeedsDisplay()
        }
    }

    init() {
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {
        let y: CGFloat
        switch separatorType {
        case .top:
            y = 0
        case .bottom:
            y = rect.height - Constant.separatorHeight
        }
        let rect = CGRect(x: 0, y: y, width: rect.width, height: Constant.separatorHeight)
        let path = UIBezierPath(rect: rect)
        color.setFill()
        path.fill()
    }
}
