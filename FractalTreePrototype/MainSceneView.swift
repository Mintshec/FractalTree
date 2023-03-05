//
//  ContentView.swift
//  FractalTreePrototype
//
//  Created by Cyanichord on 2023-03-05.
//

import SwiftUI

struct MainSceneView: View {
    var tree = FractalTree(upperWidth: 5*0.618, bottomWidth: 5, height: 100, angle: 0, mode: .regular)
    // branchLayout 由 branch 和 layout 组成， branch是节点
    // layout 是树枝的底部（开始点）相对于 (x: geo.size.width / 2, y: geo.size.height - 10) 的位置
    @State var branchLayouts:[BranchLayout] = []
    
    var body: some View {
        GeometryReader { geo in
            //每按一次按钮，加一层树枝
            Button("plus1") {
                tree.generateGoldenRatioBranch()
                branchLayouts = tree.layout
            }
            
            ForEach(branchLayouts, id: \.self) { branchLayout in
                branchLayout.branch.path
                    .fill(Color.cyan)
                    .offset(x: geo.size.width / 2, y: geo.size.height - 10)
            }
        }
    }
}
