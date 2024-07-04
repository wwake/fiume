import SwiftUI

struct StreamView: View {
  @Environment(People.self)
  var people: People

  @Environment(Plans.self)
  var plans: Plans

  @Binding var plan: Plan

  var stream: Stream

  init(plan: Binding<Plan>) {
    self._plan = plan
    self.stream = plan.wrappedValue.stream!
  }

	var body: some View {
    HStack {
      if stream.isNonNegative {
        Image(systemName: "arrow.up")
          .accessibilityLabel("income stream")
      } else {
        Image(systemName: "arrow.down")
          .accessibilityLabel("expense stream")
      }

      Text("\(stream.name)   $\(stream.monthlyAmount)/mo" +
           "   Months: \(stream.first.description(people))-\(stream.last.description(people))")
      Spacer()
      Button(action: {
        plans.remove(plan)
      }) {
        Image(systemName: "trash")
          .accessibilityLabel(Text("Delete"))
      }
      .buttonStyle(.plain)
    }
    .padding(4)
    .background(stream.isNonNegative ? Color("Income") : Color("Expense"))
	}
}

#Preview {
  @State var people = People()
  @State var plans = Plans()
  @State var income = Plan.makeStream(Stream("Salary", 1_000, first: .month(2020.jan), last: .month(2025.dec)))
  @State var expense = Plan.makeStream(Stream("Car", -300, first: .month(2030.mar), last: .unchanged))
  return VStack {
    StreamView(plan: $income)
    Divider()
    StreamView(plan: $expense)
  }
  .environment(people)
  .environment(plans)
}
