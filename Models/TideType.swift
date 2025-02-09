import Foundation

enum TideType: String, CaseIterable, Identifiable {
    case normal = "Normal Tide"
    case spring = "Spring Tide"
    case neap = "Neap Tide"
    case low = "Low Tide"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .normal:
            return "Regular tidal pattern caused by Moon's gravitational pull"
        case .spring:
            return "Higher tides when Sun and Moon align, combining their gravitational forces"
        case .neap:
            return "Lower tides when Sun and Moon are at right angles, partially canceling their effects"
        case .low:
            return "Minimal tidal effect when Moon is farthest from Earth"
        }
    }
    
    var formula: String {
        switch self {
        case .normal:
            return "F = G * (M * m) / r²"
        case .spring:
            return "F = G * ((M + S) * m) / r²"
        case .neap:
            return "F = G * (|M - S| * m) / r²"
        case .low:
            return "F = G * (M * m) / r³"
        }
    }
    
    var explanation: String {
        switch self {
        case .normal:
            return "The Moon's gravity pulls on Earth's oceans, creating two bulges: one facing the Moon and one on the opposite side. As Earth rotates, these bulges cause high and low tides."
        case .spring:
            return "Spring tides occur during new and full moons when the Sun, Moon, and Earth align. The combined gravitational forces create higher high tides and lower low tides."
        case .neap:
            return "Neap tides happen during quarter moons when the Sun and Moon are at right angles to Earth. Their gravitational forces partially cancel out, resulting in smaller tidal ranges."
        case .low:
            return "When the Moon is at its farthest point from Earth (apogee), its gravitational pull is weaker, resulting in smaller tidal ranges. This follows the inverse cube law of tidal force."
        }
    }
    
    var didYouKnow: String {
        switch self {
        case .normal:
            return "Most coastal areas experience two high tides and two low tides each day!"
        case .spring:
            return "Spring tides don't just happen in spring - they occur throughout the year during new and full moons!"
        case .neap:
            return "The word 'neap' comes from Anglo-Saxon, meaning 'without power' or 'very small'!"
        case .low:
            return "The Moon's distance from Earth varies by about 50,000 kilometers throughout its orbit!"
        }
    }
} 