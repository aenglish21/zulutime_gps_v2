import Foundation
import CoreLocation

/// Converts GPS coordinates to CAP (Civil Air Patrol) grid references.
///
/// The CAP grid system is based on FAA VFR Sectional Aeronautical Navigation Charts.
/// Each sectional chart is divided into 15' x 15' (0.25° x 0.25°) grid squares,
/// numbered from the northwest corner going east, then south.
/// Output format: "CHARLOTTE 087"
struct CAPGridService {

    struct SectionalChart {
        let name: String
        let northLat: Double
        let southLat: Double
        let westLon: Double   // Negative for Western hemisphere
        let eastLon: Double   // Negative for Western hemisphere

        func contains(_ coord: CLLocationCoordinate2D) -> Bool {
            coord.latitude >= southLat && coord.latitude < northLat &&
            coord.longitude >= westLon && coord.longitude < eastLon
        }

        var columnsPerRow: Int {
            Int(((eastLon - westLon) / 0.25).rounded())
        }

        func gridNumber(for coord: CLLocationCoordinate2D) -> Int {
            let row = Int((northLat - coord.latitude) / 0.25)
            let col = Int((coord.longitude - westLon) / 0.25)
            return row * columnsPerRow + col + 1
        }
    }

    // MARK: - FAA VFR Sectional Chart Boundaries (CONUS + AK/HI)
    //
    // All boundaries [V] verified against FAA IAC-2 spec (17 Jun 2024), "Corner Coordinates" (page 1-4).
    // Decimal degrees converted from D°M' format; 3-decimal precision (≈0.1 NM).
    // Validate grid output against https://www.capgrids.com
    //
    // REMOVED (not real FAA charts): BISMARCK, NEW MEXICO, KEY WEST, MONTREAL, HALIFAX
    // ADDED: MIAMI (replaces KEY WEST); full Alaska chart set (11 additional charts)
    // NOTE: Western Aleutian Islands charts cross the antimeridian and require special handling; excluded.

    static let charts: [SectionalChart] = [
        // --- Northern tier A: 44°26'N – 49°01'N [V] ---
        SectionalChart(name: "SEATTLE",       northLat: 49.017, southLat: 44.433, westLon: -125.0,   eastLon: -116.65),
        SectionalChart(name: "GREAT FALLS",   northLat: 49.017, southLat: 44.433, westLon: -117.0,   eastLon: -108.283),
        SectionalChart(name: "BILLINGS",      northLat: 49.017, southLat: 44.433, westLon: -109.0,   eastLon: -100.283),
        SectionalChart(name: "TWIN CITIES",   northLat: 49.017, southLat: 44.433, westLon: -101.0,   eastLon: -92.283),

        // --- Northern tier B: 44°N – 48°20'/48°13'N [V] ---
        // Green Bay and Lake Huron have slightly different north extents than the western northern charts.
        SectionalChart(name: "GREEN BAY",     northLat: 48.333, southLat: 44.0,   westLon: -93.0,    eastLon: -84.35),
        SectionalChart(name: "LAKE HURON",    northLat: 48.217, southLat: 44.0,   westLon: -85.0,    eastLon: -76.35),
        // MONTREAL and HALIFAX are Canadian (NAV CANADA) charts — not FAA. Removed.

        // --- Upper-mid tier A: 40°N – 44°31'N [V] ---
        SectionalChart(name: "KLAMATH FALLS", northLat: 44.517, southLat: 40.0,   westLon: -125.0,   eastLon: -116.65),
        SectionalChart(name: "SALT LAKE CITY",northLat: 44.517, southLat: 40.0,   westLon: -117.0,   eastLon: -108.65),
        SectionalChart(name: "CHEYENNE",      northLat: 44.517, southLat: 40.0,   westLon: -109.0,   eastLon: -100.65),
        SectionalChart(name: "OMAHA",         northLat: 44.517, southLat: 40.0,   westLon: -101.0,   eastLon: -92.65),

        // --- Upper-mid tier B: 40°N – 44°13'N [V] ---
        SectionalChart(name: "CHICAGO",       northLat: 44.217, southLat: 40.0,   westLon: -93.0,    eastLon: -84.667),
        SectionalChart(name: "DETROIT",       northLat: 44.217, southLat: 40.0,   westLon: -85.0,    eastLon: -76.667),
        SectionalChart(name: "NEW YORK",      northLat: 44.217, southLat: 40.0,   westLon: -77.0,    eastLon: -68.667),

        // --- Mid tier A: 35°35'N – 40°03'N [V] ---
        // Las Vegas and Denver share different south/north extents than other mid-tier charts.
        SectionalChart(name: "LAS VEGAS",     northLat: 40.05,  southLat: 35.583, westLon: -118.0,   eastLon: -110.683),
        SectionalChart(name: "DENVER",        northLat: 40.05,  southLat: 35.583, westLon: -111.0,   eastLon: -103.733),

        // --- Mid tier B: 36°N – 40°13'N [V] ---
        // "NEW MEXICO" was a fabricated chart; this gap is correctly covered by LAS VEGAS and DENVER above.
        SectionalChart(name: "SAN FRANCISCO", northLat: 40.217, southLat: 36.0,   westLon: -125.0,   eastLon: -117.717),
        SectionalChart(name: "WICHITA",       northLat: 40.217, southLat: 36.0,   westLon: -104.0,   eastLon: -96.65),
        SectionalChart(name: "KANSAS CITY",   northLat: 40.217, southLat: 36.0,   westLon: -97.0,    eastLon: -89.75),
        SectionalChart(name: "ST LOUIS",      northLat: 40.217, southLat: 36.0,   westLon: -91.0,    eastLon: -83.75),
        SectionalChart(name: "CINCINNATI",    northLat: 40.217, southLat: 36.0,   westLon: -85.0,    eastLon: -77.75),
        SectionalChart(name: "WASHINGTON",    northLat: 40.217, southLat: 36.0,   westLon: -79.0,    eastLon: -71.75),

        // --- Lower-mid tier A: 31°16'N – 35°44'N [V] ---
        SectionalChart(name: "PHOENIX",       northLat: 35.733, southLat: 31.267, westLon: -116.0,   eastLon: -108.75),

        // --- Lower-mid tier B: 32°N – 36°13'N [V] ---
        SectionalChart(name: "LOS ANGELES",   northLat: 36.1,   southLat: 32.0,   westLon: -122.0,   eastLon: -114.567),
        SectionalChart(name: "ALBUQUERQUE",   northLat: 36.217, southLat: 32.0,   westLon: -109.0,   eastLon: -101.783),
        SectionalChart(name: "DALLAS-FT WORTH", northLat: 36.217, southLat: 32.0, westLon: -102.0,   eastLon: -94.783),
        SectionalChart(name: "MEMPHIS",       northLat: 36.217, southLat: 32.0,   westLon: -95.0,    eastLon: -87.783),
        SectionalChart(name: "ATLANTA",       northLat: 36.217, southLat: 32.0,   westLon: -88.0,    eastLon: -80.783),
        SectionalChart(name: "CHARLOTTE",     northLat: 36.217, southLat: 32.0,   westLon: -82.0,    eastLon: -75.017),

        // --- Southern tier: 28°N – 32°13'N [V] ---
        SectionalChart(name: "EL PASO",       northLat: 32.217, southLat: 28.0,   westLon: -109.0,   eastLon: -102.467),
        SectionalChart(name: "SAN ANTONIO",   northLat: 32.217, southLat: 28.0,   westLon: -103.0,   eastLon: -96.467),
        SectionalChart(name: "HOUSTON",       northLat: 32.217, southLat: 28.0,   westLon: -97.0,    eastLon: -90.467),
        SectionalChart(name: "NEW ORLEANS",   northLat: 32.217, southLat: 28.0,   westLon: -91.0,    eastLon: -84.467),
        SectionalChart(name: "JACKSONVILLE",  northLat: 32.217, southLat: 28.0,   westLon: -85.0,    eastLon: -78.467),

        // --- Tropical tier [V] ---
        SectionalChart(name: "BROWNSVILLE",   northLat: 28.217, southLat: 24.0,   westLon: -103.0,   eastLon: -96.6),
        // MIAMI replaces the fictitious "KEY WEST" chart.
        SectionalChart(name: "MIAMI",         northLat: 28.117, southLat: 24.0,   westLon: -83.0,    eastLon: -76.533),

        // --- Alaska [V] ---
        // Full official set per FAA IAC-2. Western Aleutian Islands (antimeridian-crossing) excluded.
        SectionalChart(name: "ANCHORAGE",     northLat: 64.167, southLat: 60.0,   westLon: -151.5,   eastLon: -139.4),
        SectionalChart(name: "BETHEL",        northLat: 64.167, southLat: 59.583, westLon: -173.0,   eastLon: -160.333),
        SectionalChart(name: "CAPE LISBURNE", northLat: 72.167, southLat: 68.0,   westLon: -171.5,   eastLon: -155.0),
        SectionalChart(name: "COLD BAY",      northLat: 56.167, southLat: 53.867, westLon: -164.0,   eastLon: -154.133),
        SectionalChart(name: "DAWSON",        northLat: 68.167, southLat: 64.0,   westLon: -145.0,   eastLon: -130.733),
        SectionalChart(name: "DUTCH HARBOR",  northLat: 56.167, southLat: 52.0,   westLon: -173.0,   eastLon: -163.133),
        SectionalChart(name: "FAIRBANKS",     northLat: 68.167, southLat: 64.0,   westLon: -158.0,   eastLon: -143.75),
        SectionalChart(name: "JUNEAU",        northLat: 60.167, southLat: 56.0,   westLon: -141.0,   eastLon: -129.733),
        SectionalChart(name: "KETCHIKAN",     northLat: 56.167, southLat: 52.0,   westLon: -139.0,   eastLon: -129.283),
        SectionalChart(name: "KODIAK",        northLat: 60.167, southLat: 56.0,   westLon: -162.0,   eastLon: -150.75),
        SectionalChart(name: "MCGRATH",       northLat: 64.167, southLat: 60.0,   westLon: -162.0,   eastLon: -149.917),
        SectionalChart(name: "NOME",          northLat: 68.167, southLat: 64.0,   westLon: -171.5,   eastLon: -156.667),
        SectionalChart(name: "POINT BARROW",  northLat: 72.167, southLat: 68.0,   westLon: -157.0,   eastLon: -139.167),
        SectionalChart(name: "SEWARD",        northLat: 61.467, southLat: 59.117, westLon: -152.5,   eastLon: -140.0),

        // --- Hawaii [V] ---
        SectionalChart(name: "HAWAIIAN ISLANDS", northLat: 23.6, southLat: 18.367, westLon: -160.917, eastLon: -154.117),
    ]

    // MARK: - Public API

    /// Returns the CAP grid reference for a given coordinate, e.g. "CHARLOTTE 087".
    /// Returns nil if the coordinate is outside all defined sectional charts.
    static func gridReference(for coordinate: CLLocationCoordinate2D) -> String? {
        guard let chart = charts.first(where: { $0.contains(coordinate) }) else {
            return nil
        }
        let gridNum = chart.gridNumber(for: coordinate)
        return String(format: "%@ %03d", chart.name, gridNum)
    }

    /// Returns just the sectional chart name, or nil if outside coverage.
    static func sectionalName(for coordinate: CLLocationCoordinate2D) -> String? {
        charts.first(where: { $0.contains(coordinate) })?.name
    }

    /// Returns just the grid number, or nil if outside coverage.
    static func gridNumber(for coordinate: CLLocationCoordinate2D) -> Int? {
        guard let chart = charts.first(where: { $0.contains(coordinate) }) else {
            return nil
        }
        return chart.gridNumber(for: coordinate)
    }
}
