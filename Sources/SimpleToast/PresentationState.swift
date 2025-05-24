import Foundation

enum PresentationState<Item: Identifiable> {
    case isPresented(Bool)
    case item(Item?)

    var isPresented: Bool {
        switch self {
        case .isPresented(let isPresented):
            isPresented
        case .item(let item):
            item != nil
        }
    }

    var item: Item? {
        switch self {
        case .isPresented:
            if isPresented {
                if let item = EmptyIdentifiable() as? Item {
                    item
                } else {
                    preconditionFailure(
                        """
                        Item must be EmptyIdentifiable when using .isPresented state with a boolean binding.
                        This is an internal library error.
                        """
                    )
                }
            } else {
                nil
            }
        case .item(let item):
            item
        }
    }

    mutating func dismiss() {
        switch self {
        case .isPresented:
            self = .isPresented(false)
        case .item:
            self = .item(nil)
        }
    }
}

struct EmptyIdentifiable: Identifiable {
    var id: Int { 0 }

    init() {}
}
