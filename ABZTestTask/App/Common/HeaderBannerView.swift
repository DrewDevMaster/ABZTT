import SwiftUI

struct HeaderBannerView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(FontName.regular.fontNunitoSansFontWeightSans(20))
            .foregroundColor(.onSurface)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.basePrimary)
    }
}

#Preview {
    HeaderBannerView(title: LocalizeStrings.headerGetMsg)
}
