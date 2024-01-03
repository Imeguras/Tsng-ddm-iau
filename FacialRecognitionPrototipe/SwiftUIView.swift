import MapKit
import UIKit
import SwiftUI

struct SwiftUIView: View {
    
    @State private var search: String = ""
    @State private var names: [MKMapItem] = [MKMapItem]()

    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    
    var body: some View {
        ZStack{
            Map().ignoresSafeArea(.all, edges: .all)
            
            GeometryReader{proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                return AnyView(
                    ZStack{
                        VStack {
                            Capsule()
                                .fill(Color.gray)
                                .frame(width: 50, height: 5)
                                .padding(.top)
                                .padding(.bottom, 5)
                            HStack(spacing: 15) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 22))
                                    .foregroundColor(.gray)
                                
                                TextField("Search Place", text: $search)
                                    .onTapGesture {
                                        lastOffset = -(height - 200)
                                        onChange()
                                    }
                                    .onSubmit {
                                        names.removeAll()
                                        LocationService.search(query: search) { results in
                                            print(results)
                                            names.append(contentsOf: results)
                                        }
                                    }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(BlurView(style: .systemMaterial))
                            .cornerRadius(15)
                            .padding()
                            Rectangle().fill(Color.gray).frame(height: 0.5)
                            BottomSheet(names: names)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                    .offset(y: height - 200)
                    .offset(y: offset)
                    .gesture(DragGesture().updating($gestureOffset, body: {
                        value, out, _ in
                        out = value.translation.height
                        onChange()
                    }).onEnded({ value in
                        let maxHeight = height - 200
                        withAnimation{
                            if -offset > 200 && -offset < maxHeight / 2 {
                                offset = -(maxHeight/3)
                            }
                            else if -offset > maxHeight / 2 {
                                offset = -maxHeight
                            }
                            else {
                                offset = 0
                            }
                        }
                        lastOffset = offset
                    }))
                )
            }.ignoresSafeArea(.all, edges: .bottom)
        }
    }

    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
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

struct CustomCorner : Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct BottomSheet : View {
    var names: [MKMapItem]

    var body: some View {
        HStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack(alignment: .leading, spacing: 15, content: {
                    if names.count > 0 {
                        ForEach(names, id: \.self) { name in
                            Text(name.name ?? "")
                        }
                    }
                    else {
                        Text("No results")
                    }
                })
                .padding()
            })
        }
    }
}
