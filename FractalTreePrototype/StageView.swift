//
//  StageView.swift
//  FractalTreePrototype
//
//  Created by Cyanichord on 2023-03-05.
//

import SwiftUI

struct StageView: View {
    var body: some View {
        ZStack {
            MainSceneView()
                .zIndex(0)
            BackgroundView()
                .zIndex(-1)
        }
    }
}
