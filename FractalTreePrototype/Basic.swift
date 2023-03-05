//
//  Basic.swift
//  FractalTreePrototype
//
//  Created by Cyanichord on 2023-03-05.
//

import Foundation

extension CGPoint {
    func rotated(around point: CGPoint, by angle: Double) -> CGPoint {
        let radian = angle * Double.pi / 180
        let cosX = cos(radian)
        let sinX = sin(radian)
        let xDistance = x - point.x
        let yDistance = y - point.y
        let rotatedX = xDistance * cosX - yDistance * sinX + point.x
        let rotatedY = xDistance * sinX + yDistance * cosX + point.y
        return CGPoint(x: rotatedX, y: rotatedY)
    }
}
