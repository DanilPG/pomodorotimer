import SwiftUI

struct CircleTimer: View {
  let fraction: Double
  let primaryText: String
  let secondaryText: String
  
  var body: some View {
    ZStack {

      Circle()
            .fill(Color("Circle")).opacity(0.1)

      Circle()
            
        .trim(from: 0, to: fraction)

        .stroke(Color("Button"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
        .opacity(0.8)
        .rotationEffect(.init(degrees: -90))
        .padding()
        .animation(.easeInOut, value: fraction)
      
      // primary text
      Text(primaryText)
        .font(.system(size: 50, weight: .semibold, design: .rounded))
        .foregroundColor(Color("Button"))
      
      // secondary text
      Text(secondaryText)
        .font(.system(size: 30, weight: .light, design: .rounded))
        .foregroundColor(Color("Button"))
        .offset(y: 50)
    }
    .padding()
  }
}

#Preview {
  CircleTimer(fraction: 0.5, primaryText: "12:34", secondaryText: "working")
}
