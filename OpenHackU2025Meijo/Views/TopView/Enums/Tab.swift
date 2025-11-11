import Foundation

enum Tab: Int, CaseIterable {
    case home, others, add, search, account

    var systemImage: String {
        switch self {
        case .home:    return "house"
        case .others:  return "person.3"
        case .add:     return "plus.circle.fill"
        case .search:  return "magnifyingglass.circle"
        case .account: return "person.crop.circle"
        }
    }

    var filledSystemImage: String {
        switch self {
        case .home:    return "house.fill"
        case .others:  return "person.3.fill"
        case .add:     return "plus.circle"
        case .search:  return "magnifyingglass.circle.fill"
        case .account: return "person.crop.circle.fill"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .home:    return "Home"
        case .others:  return "Others"
        case .add:     return "Add"
        case .search:  return "Search"
        case .account: return "Account"
        }
    }
}
