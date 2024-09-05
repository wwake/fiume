import fiume_model
import SwiftUI

struct PlanListView: View {
  @Bindable var possibilities: Possibilities

  var body: some View {
    List {
      ForEach($possibilities.plans, id: \.id) { $planTree in
        OutlineGroup(
          $planTree,
          id: \.id,
          children: \.children
        ) { $tree in
            PlanView(plan: $tree)
        }
      }
    }
    .listStyle(.grouped)
    .padding()
  }
}

#Preview {
  @State var plans = Plans()
  @State var people = People()

  let possibilities = Possibilities(startDate: MonthYear(date: Date()), plans: plans)
  let stream = Plan.make(Leia(
    name: "Annuity",
    amount: .money(1_000),
    dates: DateRange(.month(2020.jan), .unchanged),
    type: .income,
    growth: Assumption.defaultGrowth
  ))
  possibilities.plans[0].append(stream)

  return PlanListView(possibilities: possibilities)
    .environment(people)
    .environment(plans)
}
