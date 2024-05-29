import SwiftUI

struct NumberField: View {
	var label: String
	@Binding var value: Int?

	var body: some View {
		LabeledContent {
			TextField(label, value: $value, format: .number)
				.keyboardType(.decimalPad)
		} label: {
			Text(label)
		}
	}
}
