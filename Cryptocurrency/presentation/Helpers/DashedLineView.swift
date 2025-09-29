//
//  DashedLineView.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 27.09.2025.
//

import UIKit

final class DashedLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.systemGray4.cgColor)
        let dashPattern: [CGFloat] = [4, 2]
        context.setLineDash(phase: 0, lengths: dashPattern)
        
        context.move(to: CGPoint(x: 0, y: bounds.midY))
        context.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
        context.strokePath()
    }
}
