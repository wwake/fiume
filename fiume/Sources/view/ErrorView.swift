import SwiftUI

public struct ErrorView: View {
  var condition: Bool
  var message: String

  init(_ condition: Bool, _ message: String) {
    self.condition = condition
    self.message = message
  }

  public var body: some View {
    if condition {
      HStack {
        Spacer()
        Text(message)
          .foregroundStyle(Color("Error"))
        Spacer()
      }
    }
  }
}
