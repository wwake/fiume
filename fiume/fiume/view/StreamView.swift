import SwiftUI

struct StreamView: View {
	var stream: Stream

	func formatMonth(_ month: MonthNumber?) -> String {
		if let month = month {
			return "\(month)"
		}
		return "?"
	}

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
           "   Months: \(formatMonth(stream.first))-\(formatMonth(stream.last))")
    }
    .padding(4)
    .background(stream.isNonNegative ? Color("Income") : Color("Expense"))

	}
}

#Preview {
	let stream = Stream("Salary", 1_000, last: 60)
	return StreamView(stream: stream)
}
