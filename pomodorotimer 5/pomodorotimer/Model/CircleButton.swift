import SwiftUI

struct CircleButton: View {
  let icon: String
  let action: () -> Void
  
  var body: some View {
    Button {
      action()
    } label : {
      Image(systemName: icon)
            .foregroundColor(Color.white)
        .frame(width: 60, height: 60)
        .background(Color("Button"))
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
  }
}

#Preview {
  CircleButton(icon: "play.fill") {
    print("hello")
  }
}
