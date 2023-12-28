//
//  SwiftUIView.swift
//  FacialRecognitionPrototipe
//
//  Created by Carolina on 15/11/2023.
//

import MapKit
import UIKit
import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Home : View {
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2789), latitudinalMeters: 10000, longitudinalMeters: 10000)
    var body: some View {
//        ZStack(alignment: <#T##Alignment#>(horizontal: .center, vertical: .bottom), content: {
//            Map(coordinateRegion: $region)
//                .ignoresSafeArea(.all, edges: .all)
            
            BottomSheet()
//        })
        
    }
}

struct BottomSheet : View {
    
    @State var txt = ""
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 50, height: 5)
                .padding(.top)
                .padding(.bottom, 5)
            
            HStack(spacing: 15) {
                Image(systemName: "magnifyinfflass")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                
                TextField("Search Place", text: $txt)
            }
            
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(15)
            .padding()
            
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack(alignment: .leading, spacing: 15, content: {
                    ForEach(1...15, id: \.self) { count in
                    
                        Text("Searched Place")
                    }
                })
                .padding()
                .padding(.top)
            })
        }
        
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(15)
    }
}

struct BlurView : UIViewRepresentable {
    
    var style : UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView (_ uiVieww: UIVisualEffectView, context: Context) {
        
    }
}

#Preview {
    SwiftUIView()
}
