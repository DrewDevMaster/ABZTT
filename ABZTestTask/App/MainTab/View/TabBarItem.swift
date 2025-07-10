import SwiftUI

struct TabBarItem: View {
    
    @Binding var selectedTab: TabType

    let type: TabType
    private var isSelected: Bool { selectedTab == type }
    
    var body: some View {
        Button {
            selectedTab = type
        } label: {
            HStack(spacing: 8) {
                image
                title
            }
            .foregroundColor(isSelected ? .baseSecondary : .black87).opacity(0.6)
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
    
    
    @ViewBuilder
    private var title: some View {
        switch type {
        case .Users:
            Text(LocalizeStrings.usersTab)
        case .SighUp:
            Text(LocalizeStrings.signUpTab)
        }
    }
    
    @ViewBuilder
    private var image: some View {
        switch type {
        case .Users:
            Image(systemName: "person.3.fill")
        case .SighUp:
            Image(systemName: "person.crop.circle.badge.plus")
        }
    }
}
