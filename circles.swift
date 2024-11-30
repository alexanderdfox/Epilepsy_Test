import SwiftUI

struct ContentView: View {
    @State private var spinA = false
    @State private var spinZ = false
    @State private var tileSize: CGFloat = 100 // State for controlling the tile size
    @State private var layerOffsetX: CGFloat = 50 // State for controlling the horizontal offset of the layer
    @State private var layerOffsetY: CGFloat = 50 // State for controlling the vertical offset of the layer

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Calculate the number of columns and rows based on the tile size
                let columns = Int(geometry.size.width / tileSize) + 2
                let rows = Int(geometry.size.height / tileSize) + 2

                // We extract the ForEach into separate variables for clarity
                let gridItems = (0..<rows).flatMap { row in
                    (0..<columns).map { column in
                        TilePosition(
                            column: column,
                            row: row,
                            offsetX: CGFloat(column) * tileSize - (tileSize),
                            offsetY: CGFloat(row) * tileSize - (tileSize)
                        )
                    }
                }
                
                // Tile the screen
                ForEach(gridItems, id: \.self) { item in
                    let randomSpinDirection = Bool.random()

                    SingleCircleView(spinA: $spinA, spinZ: $spinZ, randomSpinDirection: randomSpinDirection, tileSize: $tileSize, layerOffsetX: $layerOffsetX, layerOffsetY: $layerOffsetY)
                        .frame(width: tileSize, height: tileSize)
                        .offset(x: item.offsetX + (item.row.isMultiple(of: 2) ? 0 : -tileSize), y: item.offsetY)
                }
            }
            .onAppear {
                spinA.toggle()
                spinZ.toggle()
            }
            .ignoresSafeArea() // Make sure the content spans the entire screen
        }
        .edgesIgnoringSafeArea(.all) // Ensure full-screen display without any safe area padding
    }
}

struct TilePosition: Hashable {
    let column: Int
    let row: Int
    let offsetX: CGFloat
    let offsetY: CGFloat
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
            // Only One Spin Layer
            Circle()
                .fill(AngularGradient(
                    gradient: Gradient(colors: [
                        .red, .orange, .yellow, .green, .cyan, .blue, .purple, .magenta, .red
                    ]),
                    center: .center
                ))
                .rotationEffect(.degrees(spinA ? 360 : 0))
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: spinA
                )
                .opacity(0.5)

            // Apply dynamic offset for the single layer
            Circle()
                .fill(AngularGradient(
                    gradient: Gradient(colors: [
                        .blue, .purple, .cyan, .green, .yellow, .orange, .red, .magenta, .blue
                    ]),
                    center: .center
                ))
                .rotationEffect(.degrees(randomSpinDirection ? -360 : 360))
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: spinZ
                )
                .opacity(0.5)
                .offset(x: layerOffsetX, y: layerOffsetY) // Apply dynamic offset based on state
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
