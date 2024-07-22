import fiume_model
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
        plans.replace(plan, pool)
      }
    }
  }
}

#Preview {
  @State var people = People()
  @State var plans = Plans()
  @State var asset = Plan.make(
    pool: Leia(
      name: "Savings",
      amount: 1_000,
      dates: DateRange(.month(2020.jan), .month(2025.dec))
    )
  )
  @State var liability = Plan.make(pool: Leia(
    name: "Car",
    amount: -300,
    dates: DateRange(.month(2030.mar), .unchanged)
  ))
  return VStack {
    PoolView(plan: $asset)
    Divider()
    PoolView(plan: $liability)
  }
  .environment(people)
  .environment(plans)
}
