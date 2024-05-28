import SwiftUI

struct StreamView: View {
	var stream: Stream

	func formatMonth(_ month: MonthNumber?) -> String {
		if let month = month {
			return "\(month)"
		}
		return "?"
	}

  func formatMonth(_ dateSpec: DateSpecifier) -> String {
    switch dateSpec {
    case .unspecified:
      return "?"

    case .month(let month):
      return "\(month)"
    }
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
           "   Months: \(formatMonth(stream.first2))-\(formatMonth(stream.last))")
      Spacer()
    }
    .padding(4)
    .background(stream.isNonNegative ? Color("Income") : Color("Expense"))
	}
}

#Preview {
  let stream = Stream("Salary", 1_000, first: .month(1), last: .month(60))
	return StreamView(stream: stream)
}
