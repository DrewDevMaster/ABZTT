import SwiftUI
import Kingfisher

struct AvatarView: View {
    
    var iconUrl: String
    
    var body: some View {
        Group {
            if let url = avatarURL {
                KFImage(url)
                    .placeholder { Image(.avatarPH) }
                    .setProcessor(
                            DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
                        )
                    .onFailure { error in
                        print("Failad loading of image url: \(iconUrl) with \(error)")
                    }
                    .fade(duration: 0.2)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.top, 4)
            } else {
                placeholder
            }
        }
        .onAppear {
            writeUrlIfNeeded()
        }
    }
    
    private var avatarURL: URL? {
        URL(string: iconUrl)
    }
    
    private var placeholder: some View {
        Image(.avatarPH)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .frame(width: 50, height: 50)
    }
    
    private func writeUrlIfNeeded() {
        if !Persistance.avatarUrlStrings.contains(iconUrl) {
            Persistance.avatarUrlStrings.insert(iconUrl)
        }
    }
}
