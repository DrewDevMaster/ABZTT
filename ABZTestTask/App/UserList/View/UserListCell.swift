import SwiftUI

struct UserListCell: View {
    
    var user: UserModel
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                AvatarView(iconUrl: user.photo)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(18))
                    .foregroundStyle(Colors.mainTextColor)
                Text(user.position)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(14))
                    .foregroundStyle(.black87.opacity(0.6))
                Text(user.email)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(14))
                    .foregroundStyle(Colors.mainTextColor)
                    .padding(.top, 4)
                Text(user.phone)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(14))
                    .foregroundStyle(Colors.mainTextColor)
                    .padding(.bottom, 24)
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.black87.opacity(0.6))
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .padding(.init(top: 24, leading: 16, bottom: 0, trailing: 16))
    }
}
