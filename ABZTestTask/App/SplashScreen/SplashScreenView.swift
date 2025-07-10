import SwiftUI

struct SplashScreenView: View {
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            ZStack {
                Color(.basePrimary)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Image(.splashScreenIcon)
                        .resizable()
                        .aspectRatio(95.42 / 65.09, contentMode: .fit)
                        .frame(width: screenWidth * 0.265)
                    
                    SplashScreenNameView(screenWidth: screenWidth)
                }
                
            }
        }
    }
}

struct SplashScreenNameView: View {
    
    let screenWidth: CGFloat

    @State private var textOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 20
    @State private var textBlur: CGFloat = 10
    var body: some View {
        Image(.splashScreenName)
            .resizable()
            .aspectRatio(160 / 26.35, contentMode: .fit)
            .frame(width: screenWidth * 0.444)
            .padding(.top, 15)
        
            .opacity(textOpacity)
                                .blur(radius: textBlur)
                                .offset(y: textOffset)
                                .onAppear {
                                    withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
                                        textOpacity = 1.0
                                        textOffset = 0
                                        textBlur = 0
                                    }
                                }
    }
}

#Preview {
    SplashScreenView()
}
