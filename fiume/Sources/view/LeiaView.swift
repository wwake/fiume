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

  let icons = [
    LeiaType.asset: Image(systemName: "arrowtriangle.up")
      .accessibilityLabel("asset"),

    LeiaType.income: Image(systemName: "arrow.up")
      .accessibilityLabel("income stream"),

    LeiaType.expense: Image(systemName: "arrow.down")
      .accessibilityLabel("expense stream"),

    LeiaType.liability: Image(systemName: "arrowtriangle.down")
      .accessibilityLabel("liability"),
  ]

  var body: some View {
    HStack {
      icons[leia.type]!

      Text("\(leia.type.name): \(leia.name)"
           + "   \(leia.amount)   \(leia.dates_.description(people))"
           + "    Growth: \(leia.growth!)")
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
    .background(Color(leia.type.name))
    .sheet(isPresented: $isEditPresented) {
      EditLeiaView(title: "Edit Money Source", leia: leia, buttonName: "Update") { stream in
        plans.replace(plan, stream)
      }
    }
  }
}

#Preview {
  @State var people = People()
  @State var plans = Plans()
  @State var income = Plan.make(
    Leia(
      name: "Salary",
      amount: .money(1_000),
      dates: DateRange(.month(2020.jan), .month(2025.dec)),
      type: .income,
      growth: Assumption.flatGrowth
    )
  )
  let stream = Leia(
    name: "Car",
    amount: .money(300),
    dates: DateRange(.month(2030.mar), .unchanged),
    type: .expense,
    growth: Assumption.flatGrowth
  )
  @State var expense = Plan.make(stream)
  return VStack {
    LeiaView(plan: $income)
    Divider()
    LeiaView(plan: $expense)
  }
  .environment(people)
  .environment(plans)
}