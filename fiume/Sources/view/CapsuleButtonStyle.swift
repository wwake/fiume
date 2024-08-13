import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .padding(12)
      .background(Color("ThemeDark"))
      .foregroundStyle(Color.white)
      .bold()
      .clipShape(Capsule())
      .padding(.leading, 20)
  }
}
