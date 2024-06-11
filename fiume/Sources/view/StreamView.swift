import SwiftUI

struct StreamView: View {
	var stream: Stream

	var body: some View {
    HStack {
      if stream.isNonNegative {
        Image(systemName: "arrow.up.right")
          .accessibilityLabel("income stream")
      } else {
        Image(systemName: "arrow.down.right")
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
  let stream = Stream("Salary", 1_000, first: .month(2020.jan), last: .month(2025.dec))
	return StreamView(stream: stream)
}
