//
//  CircleView.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 06/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let lineWidth: CGFloat = 1
}

class CircleView: UIView {
    var fill: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    var borderColor: UIColor = .blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var fillColor: UIColor = .blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        let path = circlePath(forRect: rect)
        fillPath(path)
        strokePath(path)
    }
    
    private func circlePath(forRect rect: CGRect) -> UIBezierPath {
        let lineWidth = Constant.lineWidth
        let origin = CGPointMake(rect.origin.x + lineWidth / 2, rect.origin.y + lineWidth / 2)
        let size = CGSizeMake(rect.width - lineWidth, rect.height - lineWidth)
        return UIBezierPath(ovalInRect: CGRect(origin: origin, size: size))
    }
    
    private func fillPath(path: UIBezierPath) {
        guard fill else { return }
        fillColor.setFill()
        path.fill()
    }
    
    private func strokePath(path: UIBezierPath) {
        borderColor.setStroke()
        path.lineWidth = Constant.lineWidth
        path.stroke()
    }
}
