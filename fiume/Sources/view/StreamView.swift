import SwiftUI

struct StreamView: View {
	var stream: Stream

	var body: some View {
    HStack {
      if stream.isNonNegative {
        Image(systemName: "plus.circle")
          .accessibilityLabel("income stream")
      } else {
        Image(systemName: "minus.circle")
          .accessibilityLabel("expense stream")
      }

      Text("\(stream.name)   $\(stream.monthlyAmount)/mo" +
           "   Months: \(stream.first)-\(stream.last)")
      Spacer()
    }
    .padding(4)
    .background(stream.isNonNegative ? Color("Income") : Color("Expense"))
	}
}

#Preview {
  let stream = Stream("Salary", 1_000, first: .month(MonthYear(.jan, 2020)), last: .month(MonthYear(.dec, 2025)))
	return StreamView(stream: stream)
}
