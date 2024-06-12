import SwiftUI

struct PlanListView: View {
  @Bindable var plan: Possibilities

  func contents(_ child: Binding<Plan>) -> Text {
    Text("ok hope")
  }

  var body: some View {
    List {
      ForEach($plan.sections, id: \.id) { $planTree in
        OutlineGroup(
          $planTree,
          id: \.id,
          children: \.children
        ) { tree in
            PlanView(plan: tree)
        }
      }
    }
    .listStyle(.grouped)
    .padding()
  }
}

#Preview {
  let plan = Possibilities(startDate: MonthYear(date: Date()))
  let stream = Stream("Annuity", Money(1_000), first: .month(2020.jan), last: .unchanged)
  plan.add(stream)
  let people = People()

  return PlanListView(plan: plan)
    .environment(people)
}
