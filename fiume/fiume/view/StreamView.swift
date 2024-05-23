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
      Image(systemName: "plus.circle")
        .accessibilityLabel("Stream")
      
      Text("\(stream.name)   $\(stream.monthlyAmount)/mo" +
           "   Months: \(formatMonth(stream.first))-\(formatMonth(stream.last))")
    }
	}
}

#Preview {
	let stream = Stream("Salary", 1_000, last: 60)
	return StreamView(stream: stream)
}
