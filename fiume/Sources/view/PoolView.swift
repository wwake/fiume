import SwiftUI

struct PoolView: View {
  @Environment(People.self)
  var people: People

  @Environment(Plans.self)
  var plans: Plans

  @Binding var plan: Plan

  var pool: Leia

  @State private var isEditPresented = false

  init(plan: Binding<Plan>) {
    self._plan = plan
    self.pool = plan.wrappedValue.leia!
  }

  var body: some View {
    HStack {
      if pool.isNonNegative {
        Image(systemName: "arrowtriangle.up")
          .accessibilityLabel("asset")
      } else {
        Image(systemName: "arrowtriangle.down")
          .accessibilityLabel("liability")
      }

      Text("\(pool.name)   $\(pool.amount)" +
           "   Months: \(pool.first.description(people))-\(pool.last.description(people))")
      Spacer()
      Button(action: {
        plans.remove(plan)
      }) {
        Image(systemName: "trash")
          .accessibilityLabel(Text("Delete"))
      }
      .buttonStyle(.plain)

      Button(action: {
        isEditPresented = true
      }) {
        Image(systemName: "square.and.pencil")
          .accessibilityLabel(Text("Edit"))
      }
      .buttonStyle(.plain)
    }
    .padding(4)
    .background(pool.isNonNegative ? Color("Asset") : Color("Liability"))
    .sheet(isPresented: $isEditPresented) {
      EditPoolView(pool: pool, buttonName: "Update") { pool in
        plans.replace(plan, stream: pool)
      }
    }
  }
}

#Preview {
  @State var people = People()
  @State var plans = Plans()
  @State var asset = Plan.makePool(
    Leia("Savings", 1_000, first: .month(2020.jan), last: .month(2025.dec))
  )
  @State var liability = Plan.makePool(Leia("Car", -300, first: .month(2030.mar), last: .unchanged))
  return VStack {
    PoolView(plan: $asset)
    Divider()
    PoolView(plan: $liability)
  }
  .environment(people)
  .environment(plans)
}
