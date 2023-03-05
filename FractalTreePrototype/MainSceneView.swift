//
//  ContentView.swift
//  FractalTreePrototype
//
//  Created by Cyanichord on 2023-03-05.
//

import SwiftUI

struct MainSceneView: View {
    var tree = FractalTree(upperWidth: 5*0.618, bottomWidth: 5, height: 100, angle: 0, mode: .regular)
    @State var branchLayouts:[BranchLayout] = []
    
    let a: [CGFloat] = [100, 100, 100]
    
    var body: some View {
        GeometryReader { geo in
            
            Button("plus1") {
                tree.generateGoldenRatioBranch()
                branchLayouts = tree.layout
            }
            
            ForEach(branchLayouts, id: \.self) { branchLayout in
                branchLayout.branch.path
            }
        }
    }
}
