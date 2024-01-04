import MapKit
import UIKit
import SwiftUI

struct SwiftUIView: View {
    @StateObject private var mapData = MapViewModel()
    @State private var locationManager = CLLocationManager()
    
    @State private var showLocationsList = false
    @State private var hideLocationsList = false
    
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    
    var body: some View {
        ZStack{
            MapView()
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
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
                                
                                TextField("Search Place", text: $mapData.searchText).accentColor(.black)
                                    .onTapGesture {
                                        offset = -(height - 200)
                                        showLocationsList.toggle()
                                    }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(BlurView(style: .systemMaterial))
                            .cornerRadius(15)
                            .padding()
                            Rectangle().fill(Color.gray).frame(height: 0.5)
                            
                            ScrollView(.vertical, showsIndicators: false, content: {
                                LazyVStack(alignment: .leading, spacing: 15, content: {
                                    if !mapData.locations.isEmpty && mapData.searchText != "" {
                                        ForEach(mapData.locations) { location in
                                            Text(location.place.name ?? "").onTapGesture {
                                                offset = 0
                                                hideLocationsList.toggle()
                                                mapData.searchText = location.place.name ?? mapData.searchText
                                                showRouteOnMap(pickupCoordinate: mapData.region.center, destinationCoordinate: location.coordinate)
                                            }
                                            Text(location.getCaption()).font(.caption)
                                            Divider()
                                        }
                                    }
                                    else {
                                        Text("No Results")
                                    }
                                })
                                .padding()
                            })
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                        .offset(y: height - 200)
                        .offset(y: offset)
                        .animation(.spring(), value: showLocationsList)
                        .animation(.spring(), value: hideLocationsList)
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
                            showLocationsList = false
                            hideLocationsList = false
                        }))
                )
            }.ignoresSafeArea(.all, edges: .bottom)
        }.onAppear(perform: {
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        .alert(isPresented: $mapData.permissionDenied, content: {
            Alert(title: Text("Permission Denied"), message: Text("Please enable permissions in settings"), dismissButton: .default(Text("Go to Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapData.searchText) {_, value in
            let delay = 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.searchText {
                    self.mapData.search()
                }
            }
        }
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        mapData.mapView.showAnnotations([destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            mapData.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            mapData.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}
