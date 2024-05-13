import SwiftUI

struct StreamView: View {
	var stream: Stream

	var body: some View {
		Text("\(stream.name) \(stream.monthlyAmount)")
			.listRowBackground(stream.monthlyAmount < 0 ? Color.red : Color.green)
	}
}
