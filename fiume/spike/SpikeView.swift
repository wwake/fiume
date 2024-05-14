import SwiftUI

public indirect enum Tree<String> {
	case leaf(String)
	case tree(String, [Tree]?)

	var value: String {
		switch self {
		case .leaf(let value):
			return value

		case .tree(let value, _):
			return value
		}
	}

	var children: [Tree]? {
		switch self {
		case .leaf(_):
			return []

		case .tree(_, let children):
			return children
		}
	}
}

var categories: [Tree<String>] = [
	.tree(
		"Clothing",
		[
			Tree.leaf("Hoodies"),
			.leaf("Jackets"),
			.leaf("Joggers"),
			.leaf("Jumpers"),
			.tree(
				"Jeans",
				[
					.leaf("Regular"),
					.leaf("Slim")
				]
			),
		]
	),
	.tree(
		"Shoes",
		[
			.leaf("Boots"),
			.leaf("Sliders"),
			.leaf("Sandals"),
			.leaf("Trainers"),
		]
	)
]



struct SpikeView: View {

	var body: some View {
	  NavigationStack {
			List {
				ForEach(categories, id: \.value) { section in
					Section(header: HStack {
						Text(section.value)
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
