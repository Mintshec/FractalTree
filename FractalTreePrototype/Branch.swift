//
//  Branch.swift
//  FractalTreePrototype
//
//  Created by Cyanichord on 2023-03-05.
//

import SwiftUI

class Branch: Equatable, Hashable {
    private(set) var id: Int
    var name: String?
    private(set) var upperWidth: CGFloat
    private(set) var bottomWidth: CGFloat
    private(set) var height: CGFloat
    private(set) var angle: CGFloat
    private(set) var points: BranchPoint!
    
    var path: Path {
        get {
            return generatePath()
        }
    }
    
    private(set) var shape: BranchShape!
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Branch, rhs: Branch) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum BranchShape: Int {
        case error = 0
        case rectangle
        case triangle
        case trapezium
    }
    
    init(id: Int, upperWidth: CGFloat, bottomWidth: CGFloat, height: CGFloat, angle: CGFloat) {
        self.id = id
        
        self.upperWidth = max(upperWidth, 0)
        self.bottomWidth = max(bottomWidth, 0)
        self.height = max(height, 0)
        self.angle = angle
        
        switch (height, bottomWidth, upperWidth) {
        case (0, 0, _), (0, _, _), (_, 0, _):
            self.shape = .error
        case (_, _, 0):
            self.shape = .triangle
        case (_, let bottomWidth, let upperWidth) where bottomWidth == upperWidth:
            self.shape = .rectangle
        default:
            self.shape = .trapezium
        }
        
        self.points = generatePoint()
    }
}

extension Branch {
    private func generatePoint() -> BranchPoint {
        var pointUpLeft: CGPoint = CGPoint(x: 0, y: 0)
        var pointUpRight: CGPoint = CGPoint(x: 0, y: 0)
        var pointDownLeft: CGPoint = CGPoint(x: 0, y: 0)
        var pointDownRight: CGPoint = CGPoint(x: 0, y: 0)
        let difference = CGFloat(abs(self.upperWidth - self.bottomWidth))
        
        
        if self.upperWidth > self.bottomWidth {
            pointUpRight = CGPoint(x: self.upperWidth, y: 0)
            pointDownLeft = CGPoint(x: difference / 2, y: self.height)
            pointDownRight = CGPoint(x: (difference / 2) + self.bottomWidth, y: self.height)
        } else {
            pointUpLeft = CGPoint(x: (difference / 2), y: 0)
            pointUpRight = CGPoint(x: (difference / 2) + self.upperWidth, y: 0)
            pointDownLeft = CGPoint(x: 0, y: self.height)
            pointDownRight = CGPoint(x: self.bottomWidth, y: self.height)
        }
        
        let pointCenter = CGPoint(x: (pointUpLeft.x + pointUpRight.x + pointDownLeft.x + pointDownRight.x) / 4, y: (pointUpLeft.y + pointUpRight.y + pointDownLeft.y + pointDownRight.y) / 4)
        
        let bottom = CGPoint(x: (pointDownLeft.x + pointDownRight.x) / 2, y: (pointDownLeft.y + pointDownRight.y) / 2)
        
        
        if angle != 0 {
            pointUpLeft = pointUpLeft.rotated(around: bottom, by: angle)
            pointUpRight = pointUpRight.rotated(around: bottom, by: angle)
            pointDownLeft = pointDownLeft.rotated(around: bottom, by: angle)
            pointDownRight = pointDownRight.rotated(around: bottom, by: angle)
        }
        
        let branchPoint = BranchPoint(upLeft: pointUpLeft, upRight: pointUpRight, downLeft: pointDownLeft, downRight: pointDownRight)
        
        return branchPoint
    }
}

extension Branch {
    private func generatePath() -> Path {
        let branchPoint = self.points!
        
        let path = Path { path in
            path.move(to: branchPoint.upLeft)
            path.addLine(to: branchPoint.upRight)
            path.addLine(to: branchPoint.downRight)
            path.addLine(to: branchPoint.downLeft)
            path.closeSubpath()
        }
        
        return path
    }
}


class BranchPoint {
    private(set) var upLeft: CGPoint
    private(set) var upRight: CGPoint
    private(set) var downLeft: CGPoint
    private(set) var downRight: CGPoint
    private(set) var top: CGPoint
    private(set) var bottom: CGPoint
    private(set) var group: [CGPoint]
    
    init(upLeft: CGPoint, upRight: CGPoint, downLeft: CGPoint, downRight: CGPoint) {
        let top = CGPoint(x: (upLeft.x + upRight.x) / 2, y: (upLeft.y + upRight.y) / 2)
        let bottom = CGPoint(x: (downLeft.x + downRight.x) / 2, y: (downLeft.y + downRight.y) / 2)

        
        let distanceX:CGFloat = bottom.x
        let distanceY:CGFloat = bottom.y
        
        let topX = top.x - distanceX
        let topY = top.y - distanceY
        let bottomX = bottom.x - distanceX
        let bottomY = bottom.y - distanceY
        let uLX = upLeft.x - distanceX
        let uLY = upLeft.y - distanceY
        let uRX = upRight.x - distanceX
        let uRY = upRight.y - distanceY
        let dRX = downRight.x - distanceX
        let dRY = downRight.y - distanceY
        let dLX = downLeft.x - distanceX
        let dLY = downLeft.y - distanceY
        
        self.top = CGPoint(x: topX, y: topY)
        self.bottom = CGPoint(x: bottomX, y: bottomY)
        self.upLeft = CGPoint(x: uLX, y: uLY)
        self.upRight = CGPoint(x: uRX, y: uRY)
        self.downRight = CGPoint(x: dRX, y: dRY)
        self.downLeft = CGPoint(x: dLX, y: dLY)
        
        group = [self.top, self.bottom, self.upLeft, self.upRight, self.downRight, self.downLeft]
    }
    
    func offset(x: CGFloat, y: CGFloat) {
        self.top = CGPoint(x: self.top.x + x, y: self.top.y + y)
        self.bottom = CGPoint(x: self.bottom.x + x, y: self.bottom.y + y)
        self.upLeft = CGPoint(x: self.upLeft.x + x, y: self.upLeft.y + y)
        self.upRight = CGPoint(x: self.upRight.x + x, y: self.upRight.y + y)
        self.downLeft = CGPoint(x: self.downLeft.x + x, y: self.downLeft.y + y)
        self.downRight = CGPoint(x: self.downRight.x + x, y: self.downRight.y + y)
    }
}
