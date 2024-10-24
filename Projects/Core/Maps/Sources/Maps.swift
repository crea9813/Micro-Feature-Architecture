import Foundation
import NMapsMap

public class Maps: NSObject {
    public weak var markerDelegate: NMFMarkerDelegate?
    
    public let mapView: NMFMapView
    
    override public init() {
        self.mapView = NMFMapView()
    }
}

public enum MarkersLoadingState {
    case required
    case loading
    case end
}
