import SwiftUI

struct PoolView: View {
  @Binding var plan: Plan

  var body: some View {
    Text("Hello, Pool!")
  }
}

#Preview {
  @State var plan = Plan.makeGroup("required")
  return PoolView(plan: $plan)
}
