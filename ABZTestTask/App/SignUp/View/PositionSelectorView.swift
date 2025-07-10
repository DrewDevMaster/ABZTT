import SwiftUI

struct PositionSelectorView: View {
    
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizeStrings.selectYourPosition)
                .multilineTextAlignment(.leading)
                .padding()
                .font(FontName.regular.fontNunitoSansFontWeightSans(18))
                .foregroundStyle(Colors.mainTextColor)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.positions) { position in
                    Button(action: {
                        viewModel.selectedPositionId = position.id
                    }) {
                        HStack {
                            Circle()
                                .strokeBorder(
                                    viewModel.selectedPositionId == position.id ? .baseSecondary : .noNamedTFBorder,
                                    lineWidth: viewModel.selectedPositionId == position.id ? 4 : 1
                                )
                                .frame(width: 14, height: 14)
                            
                            Text(position.name)
                                .font(FontName.regular.fontNunitoSansFontWeightSans(18))
                                .foregroundStyle(Colors.mainTextColor)
                                .padding(.leading, 25)
                        }
                    }
                }
            }
            .padding(.leading, 40)
        }
    }
}
