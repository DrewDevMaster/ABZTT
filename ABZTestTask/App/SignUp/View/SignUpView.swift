import SwiftUI
import PhotosUI

struct SignUpView: View {
    
    @StateObject var viewModel: SignUpViewModel

    @State private var isNeedShowNameError = false
    @State private var isNeedShowEmailError = false
    @State private var isNeedShowPhoneError = false
    
    var body: some View {
        ZStack {
            VStack() {
                HeaderBannerView(title: LocalizeStrings.headerPostMsg)
                    .padding(.top, 1)
                ScrollView() {
                    VStack(spacing: 12) {
                        CustomTextField(
                            placeholder: LocalizeStrings.yourName,
                            text: $viewModel.name,
                            msg: viewModel.name.count < 2 ? LocalizeStrings.requiredField : nil,
                            isNeedShowError: $isNeedShowNameError
                        )
                        
                        CustomTextField(
                            placeholder: LocalizeStrings.email,
                            text: $viewModel.email,
                            msg: !viewModel.email.isValidEmail() ? LocalizeStrings.invalidEmail : nil,
                            isNeedShowError: $isNeedShowEmailError
                        )
                        
                        CustomTextField(
                            placeholder: LocalizeStrings.phone,
                            text: $viewModel.phone,
                            msg: !viewModel.phone.isValidPhoneNumber() ? LocalizeStrings.requiredField : nil,
                            isNeedShowError: $isNeedShowPhoneError,
                            isPhoneField: true
                        )
                    }
                    .padding()
                    HStack {
                        PositionSelectorView(viewModel: viewModel)
                        Spacer()
                    }
                    UploadPhotoView(viewModel: viewModel)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            isNeedShowNameError = true
                            isNeedShowEmailError = true
                            isNeedShowPhoneError = true
                            Task {
                                await viewModel.register()
                            }
                        }) {
                            Text(LocalizeStrings.signUpTab)
                                .padding(12)
                                .padding(.leading, 12)
                                .padding(.trailing, 12)
                                .background(.basePrimary)
                                .font(FontName.regular.fontNunitoSansFontWeightSans(18))
                                .foregroundStyle(Colors.mainTextColor)
                                .cornerRadius(24)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    
                    Spacer()
                }
            }
            if viewModel.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            viewModel.preloadCache()
            viewModel.getPositions()
        }
        .fullScreenCover(isPresented: $viewModel.showSuccess) {
            SuccessOrErrorRegiterView(message: LocalizeStrings.successfullyRegistered, icon: "successRegisterIcon") {
                viewModel.showSuccess = false
            }
        }
        .fullScreenCover(isPresented: $viewModel.showError) {
            SuccessOrErrorRegiterView(message: viewModel.errorMessage, icon: "errorRegisterIcon") {
                viewModel.showError = false
            }
        }
    }
}

#Preview {
    SignUpView(
        viewModel: SignUpViewModel(
            userFetchingService: UserFetchingService(userEvents: UserEventService())
        )
    )
}
