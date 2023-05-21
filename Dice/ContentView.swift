//
//  ContentView.swift
//  Dice
//
//  Created by Jia Chen Yee on 21/5/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        boxAnchor.actions.throwDice.onAction = { entity in
            let dice = entity as! HasPhysics
            
            dice.physicsBody?.mode = .kinematic
            
            /// MARK: Spin the dice by a random value in the X, Y and Z axis
            dice.physicsMotion?.angularVelocity = [
                Float.random(in: 0 ..< 4 * .pi),
                Float.random(in: 0 ..< 4 * .pi),
                Float.random(in: 0 ..< 4 * .pi)
            ]
            
            /// MARK: Throw the dice up by 1 in the Y-axis
            dice.physicsMotion?.linearVelocity = [0, 1, 0]
            
            /// MARK: After 0.5s make the dice fall back down
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                dice.physicsMotion?.angularVelocity = [0, 0, 0]
                dice.physicsMotion?.linearVelocity = [0, 0, 0]
                dice.physicsBody?.mode = .dynamic
            }
            
        }
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
