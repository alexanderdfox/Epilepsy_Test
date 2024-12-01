import SwiftUI

struct ContentView: View {
    @State private var spinA = false
    @State private var spinZ = false
    @State private var tileSize: CGFloat = 100 // State for controlling the tile size
    @State private var layerOffsetX: CGFloat = 50 // State for controlling the horizontal offset of the layer
    @State private var layerOffsetY: CGFloat = 50 // State for controlling the vertical offset of the layer

    var body: some View {
        GeometryReader { geometry in
            // White background layer
            Color.white
            ZStack {
                // Calculate the number of columns and rows based on the tile size
                let columns = Int(geometry.size.width / tileSize) + 3 // +3 ensures coverage on the right edge
                let rows = Int(geometry.size.height / tileSize) + 3 // +3 ensures enough rows for vertical coverage

                // Generate grid items
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<columns, id: \.self) { column in
                        let offsetX = CGFloat(column) * tileSize - tileSize
                        let offsetY = CGFloat(row) * tileSize - tileSize
                        let randomSpinDirection = Bool.random()

                        SingleCircleView(
                            spinA: $spinA,
                            spinZ: $spinZ,
                            randomSpinDirection: randomSpinDirection,
                            tileSize: $tileSize,
                            layerOffsetX: $layerOffsetX,
                            layerOffsetY: $layerOffsetY
                        )
                        .frame(width: tileSize, height: tileSize)
                        .offset(
                            x: offsetX + (row.isMultiple(of: 2) ? 0 : -tileSize), // Stagger every other row
                            y: offsetY
                        )
                    }
                }
            }
            .onAppear {
                spinA = true
                spinZ = true
            }
        }
        .edgesIgnoringSafeArea(.all) // Ensure full-screen display without any safe area padding
    }
}

struct SingleCircleView: View {
    @Binding var spinA: Bool
    @Binding var spinZ: Bool
    var randomSpinDirection: Bool
    @Binding var tileSize: CGFloat
    @Binding var layerOffsetX: CGFloat
    @Binding var layerOffsetY: CGFloat

    var body: some View {
        ZStack {
            // First spinning layer
            Circle()
                .fill(AngularGradient(
                    gradient: Gradient(colors: [
                        .red, .orange, .yellow, .green, .cyan, .blue, .purple, .magenta, .red
                    ]),
                    center: .center
                ))
                .rotationEffect(.degrees(spinA ? 360 : 0))
                .animation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: false),
                    value: spinA
                )
                .opacity(0.5)

            // Second spinning layer with dynamic offset
            Circle()
                .fill(AngularGradient(
                    gradient: Gradient(colors: [
                        .blue, .purple, .cyan, .green, .yellow, .orange, .red, .magenta, .blue
                    ]),
                    center: .center
                ))
                .rotationEffect(.degrees(spinZ ? -360 : 0))
                .animation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: false),
                    value: spinZ
                )
                .opacity(0.5)
                .offset(x: layerOffsetX, y: layerOffsetY)
        }
    }
}

// Custom Colors
extension Color {
    static let lightBlue = Color(red: 0.68, green: 0.85, blue: 1.0)
    static let magenta = Color(red: 1.0, green: 0.0, blue: 1.0) // Accurate magenta
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
