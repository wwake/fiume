import SwiftUI

struct PlanListView: View {
  @Bindable var possibilities: Possibilities

  var body: some View {
    List {
      ForEach($possibilities.sections, id: \.id) { $planTree in
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
  @State var plans = [Plan]()

  let plan = Possibilities(startDate: MonthYear(date: Date()), plans: plans)
  let stream = Plan.makeStream(Stream("Annuity", Money(1_000), first: .month(2020.jan), last: .unchanged))
  plan.sections[0].append(stream)

  return PlanListView(possibilities: plan)
}
