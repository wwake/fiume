import SwiftUI

struct Tree<Value: Hashable>: Hashable {
	let value: Value
	var children: [Tree]? = nil
}

var categories: [Tree<String>] = [
	.init(
		value: "Clothing",
		children: [
			.init(value: "Hoodies"),
			.init(value: "Jackets"),
			.init(value: "Joggers"),
			.init(value: "Jumpers"),
			.init(
				value: "Jeans",
				children: [
					.init(value: "Regular"),
					.init(value: "Slim")
				]
			),
		]
	),
	.init(
		value: "Shoes",
		children: [
			.init(value: "Boots"),
			.init(value: "Sliders"),
			.init(value: "Sandals"),
			.init(value: "Trainers"),
		]
	)
]



struct SpikeView: View {

	var body: some View {
	  NavigationStack {
			List {
				ForEach(categories, id: \.self) { section in
					Section(header: HStack { Text(section.value)
						  Spacer()
						Button(
							" ",
							systemImage: "plus") {
								print("clicked")
							}
					}.foregroundStyle(.blue)) {
						OutlineGroup(
							section.children ?? [],
							id: \.value,
							children: \.children
						) { tree in
							Text(tree.value)
								.font(.subheadline)
						}
					}
				}
				.onMove { indexSet, offset in
					categories.move(fromOffsets: indexSet, toOffset: offset)
				}
				.onDelete { offsets in
					categories.remove(atOffsets: offsets)
				}

			}.listStyle(.grouped)
				.toolbar {
					EditButton()
				}
		}
	}
}

#Preview {
	SpikeView()
}
