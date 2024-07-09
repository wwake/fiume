import SwiftUI

struct EditPoolView: View {
  @Environment(\.dismiss)
  var dismiss

  var pool: Pool

  var buttonName: String
  var action: (Pool) -> Void

  @State private var isIncome = true

  @State private var name = ""

  @State private var amount: Int?
  @State private var startMonth = DateSpecifier.unchanged
  @State private var endMonth = DateSpecifier.unchanged

  var body: some View {
    Text("Hello, \(pool.name) \(pool.amount)")
  }
}

#Preview {
  @State var pool = Pool(name: "", amount: 100, first: .unchanged, last: .unchanged)
  return EditPoolView(pool: pool, buttonName: "Create") { _ in
  }
}
