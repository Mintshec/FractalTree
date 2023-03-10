//
//  FractalTree.swift
//  FractalTreePrototype
//
//  Created by Cyanichord on 2023-03-05.
//

import SwiftUI

class FractalTree {
    private(set) var root: BranchNode
    private var childCount: Int
    private(set) var mode: GoldenRaitoBranchGenerateMode
    var branch: [Branch] {
        get {
            return dfsNode(root: root)
        }
    }
    
    var layout:[BranchLayout] {
        get {
            return layout(root: self.root)
        }
    }
    enum GoldenRaitoBranchGenerateMode {
        case regular
        case complementary
        case randomMix
    }
    
    init(upperWidth: CGFloat, bottomWidth: CGFloat, height: CGFloat, angle: CGFloat, mode: GoldenRaitoBranchGenerateMode) {
        childCount = 0
        self.mode = mode
        root = BranchNode(id: 0, upperWidth: upperWidth, bottomWidth: bottomWidth, height: height, angle: angle)
    }
    
    struct LayoutParameter {
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
    }
}

extension FractalTree {
    // branchLayout 由 branch 和 layout 组成， branch是节点
    // layout 是树枝的底部（开始点）相对于 (x: geo.size.width / 2, y: geo.size.height - 10) 的位置
    // 广度优先遍历
    private func layout(root: BranchNode) -> [BranchLayout]{
        
        var layoutList: [BranchLayout] = []
        var layoutDict: [Branch : CGPoint] = [:]
        var queue: [BranchNode] = [root]
        var count = 0
        
        while queue.isEmpty == false {
            let node = queue.removeFirst()
            //由于所有的树枝都是从根部开始到顶部结束，所以当前树枝的顶部就是下个子枝的起点
            //layoutList存放的是对应树枝的起点，layoutDict存放的是对应树枝的顶点
            if count == 0 && node.id == 0 {
                //树根
                layoutList.append(BranchLayout(node.node, CGPoint(x: 0, y: 0)))
                layoutDict.updateValue(node.node.points.top, forKey: node.node)
            } else {
                let parent = node.parent!.node
                let parentGlobalTop = layoutDict[parent]!
                //父树枝顶点是当前树枝的起点
                let nodeTopX = parentGlobalTop.x + node.node.points.top.x
                let nodeTopY = parentGlobalTop.y + node.node.points.top.y
                layoutList.append(BranchLayout(node.node, parentGlobalTop))
                //将当前树枝的顶点存入字典
                layoutDict.updateValue(CGPoint(x: nodeTopX, y: nodeTopY), forKey: node.node)
            }
            count += 1
            
            if let left = node.leftChild {
                queue.append(left)
            }
            
            if let right = node.rightChild {
                queue.append(right)
            }
            
            if count == Int(pow(2.0, Double(layoutList.count))) {
                count = 0
            }
        }
        print(layoutList)
        return layoutList
    }
}

extension FractalTree {
    //以黄金分割比生成叶子结点的下一层
    func generateGoldenRatioBranch() {
        if mode == .regular || mode == .complementary {
            let ratio = mode == .regular ? 0.618 : 0.382
            let leafNode = dfsBranch(root: root)
            for node in leafNode {
                let upperWidth = node.node.upperWidth * ratio
                let bottomWidth = node.node.bottomWidth * ratio
                let height = node.node.height * ratio
                
                var leftAngle:CGFloat = 0
                var rightAngle:CGFloat = 0
                
                if node.id == 0 {
                    
                } else if node.parent!.id == 0 {
                    leftAngle = 180 * 0.618
                    rightAngle =  -180 * 0.618
                } else {
                    leftAngle = node.parent!.node.angle * ratio
                    rightAngle = node.parent!.node.angle * ratio
                }
                self.childCount += 1
                node.leftChild = BranchNode(id: self.childCount, upperWidth: upperWidth, bottomWidth: bottomWidth, height: height, angle: leftAngle)
                self.childCount += 1
                node.rightChild = BranchNode(id: self.childCount, upperWidth: upperWidth, bottomWidth: bottomWidth, height: height, angle: rightAngle)
                node.leftChild?.parent = node
                node.rightChild?.parent = node
            }
        } else {
            
        }
    }
    
    private func dfsBranch(root: BranchNode?) -> [BranchNode] {
        if root == nil { return [] }
        var leafNodeList: [BranchNode] = []
        let leftLeaf = dfsBranch(root: root!.leftChild)
        let rightLeaf = dfsBranch(root: root!.rightChild)
        if leftLeaf.isEmpty && rightLeaf.isEmpty {
            leafNodeList.append(root!)
        } else {
            leafNodeList.append(contentsOf: leftLeaf)
            leafNodeList.append(contentsOf: rightLeaf)
        }
        return leafNodeList
    }
    
    private func dfsNode(root: BranchNode?) -> [Branch] {
        if root == nil { return [] }
        var nodeList: [Branch] = []
        nodeList.append(root!.node)
        nodeList.append(contentsOf: dfsNode(root: root?.leftChild))
        nodeList.append(contentsOf: dfsNode(root: root?.rightChild))
        return nodeList
    }
}

class BranchNode {
    private(set) var id: Int
    var name: String?
    private(set) var node: Branch
    weak var parent: BranchNode?
    var leftChild: BranchNode?
    var rightChild: BranchNode?
    
    init(id: Int, upperWidth: CGFloat, bottomWidth: CGFloat, height: CGFloat, angle: CGFloat) {
        self.id = id
        self.parent = nil
        self.leftChild = nil
        self.rightChild = nil
        self.node = Branch(id: id, upperWidth: upperWidth, bottomWidth: bottomWidth, height: height, angle: angle)
    }
}

struct BranchLayout: Equatable, Hashable {
    var branch: Branch
    var point: CGPoint
    
    init(_ branch: Branch, _ point: CGPoint) {
        self.branch = branch
        self.point = point
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(branch.id)
    }
    
    static func == (lhs: BranchLayout, rhs: BranchLayout) -> Bool {
        return lhs.branch.id == rhs.branch.id
    }
}
