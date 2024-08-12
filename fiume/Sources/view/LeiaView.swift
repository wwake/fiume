import fiume_model
import SwiftUI

struct LeiaView: View {
  @Environment(People.self)
  var people: People

  @Environment(Plans.self)
  var plans: Plans

  @Binding var plan: Plan

  var leia: Leia

  @State private var isEditPresented = false

  init(plan: Binding<Plan>) {
    self._plan = plan
    self.leia = plan.wrappedValue.leia!
  }

  let typeColors = [
    LeiaType.income: "Income",
    LeiaType.expense: "Expense",
  ]

  var type: String {
    typeColors[leia.type] ?? ""
  }

  let icons = [
    LeiaType.income: Image(systemName: "arrow.up")
      .accessibilityLabel("income stream"),
    LeiaType.expense: Image(systemName: "arrow.down")
      .accessibilityLabel("expense stream"),
  ]

  var body: some View {
    HStack {
      icons[leia.type] ?? Image(systemName: "questionMark.circle")      .accessibilityLabel("unknown type")

      Text("\(type): \(leia.name)   \(leia.amount)   " +
           leia.dates.description(people))
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
    .background(Color(type))
    .sheet(isPresented: $isEditPresented) {
      EditLeiaView(title: "Edit Stream", stream: leia, buttonName: "Update") { stream in
        plans.replace(plan, stream)
      }
    }
  }
}

#Preview {
  @State var people = People()
  @State var plans = Plans()
  @State var income = Plan.make(
    stream: Leia(
      name: "Salary",
      amount: .money(1_000),
      dates: DateRange(.month(2020.jan), .month(2025.dec)),
      type: .income
    )
  )
  let stream = Leia(
    name: "Car",
    amount: .money(-300),
    dates: DateRange(.month(2030.mar), .unchanged),
    type: .expense
  )
  @State var expense = Plan.make(stream: stream)
  return VStack {
    LeiaView(plan: $income)
    Divider()
    LeiaView(plan: $expense)
  }
  .environment(people)
  .environment(plans)
}
