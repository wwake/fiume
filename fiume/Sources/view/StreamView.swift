import fiume_model
import SwiftUI

struct StreamView: View {
  @Environment(People.self)
  var people: People

  @Environment(Plans.self)
  var plans: Plans

  @Binding var plan: Plan

  var stream: Leia

  @State private var isEditPresented = false

  init(plan: Binding<Plan>) {
    self._plan = plan
    self.stream = plan.wrappedValue.leia!
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

      Text("\(stream.name)   $\(stream.amount)/mo   " +
           stream.dates.description(people))
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
    .background(stream.isNonNegative ? Color("Income") : Color("Expense"))
    .sheet(isPresented: $isEditPresented) {
      EditStreamView(stream: stream, buttonName: "Update") { stream in
        plans.replace(plan, stream)
      }
    }
  }
}

#Preview {
  @State var people = People()
  @State var plans = Plans()
  @State var income = Plan.make(
    stream: Leia(name: "Salary", amount: 1_000, dates: DateRange(.month(2020.jan), .month(2025.dec)))
  )
  let stream = Leia(name: "Car", amount: -300, dates: DateRange( .month(2030.mar), .unchanged))
  @State var expense = Plan.make(stream: stream)
  return VStack {
    StreamView(plan: $income)
    Divider()
    StreamView(plan: $expense)
  }
  .environment(people)
  .environment(plans)
}
