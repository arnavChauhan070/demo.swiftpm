import SceneKit
import SwiftUI

@MainActor
class SceneController: ObservableObject {
    @Published var scene: SCNScene?
    @Published var tideHeight: Double = 0.1
    @Published var tideType: TideType = .normal
    
    // Nodes
    private var earthNode = SCNNode()
    private var moonNode = SCNNode()
    private var sunNode = SCNNode()
    private var oceanNode = SCNNode()
    
    // Constants - Reduced sun size to optimize memory
    private let sunRadius: Double = 4.0
    private let earthRadius: Double = 1.0
    private let moonRadius: Double = 0.27
    private let sunDistance: Double = 12.0
    
    // Animation
    private var animationTimer: Timer?
    @Published var isAnimating = false
    @Published var moonDistance: Double = 1.5
    @Published var moonOrbitAngle: Double = 0
    
    // Gravitational constants (scaled for visualization)
    private let G: Double = 6.67430e-11
    private let earthMass: Double = 5.972e24
    private let moonMass: Double = 7.34767309e22
    private let sunMass: Double = 1.989e30
    private let realEarthRadius: Double = 6.371e6
    private let realMoonDistance: Double = 384.4e6
    private let realSunDistance: Double = 149.6e9
    
    // Add computed property for real world tide height
    private var realWorldTideHeight: Double {
        // Adjust scale factor to match real-world tides better
        // Normal tides are typically 1-2 meters, spring tides 2-4 meters
        return tideHeight * 10 // Reduced from 20 to get more realistic values
    }
    
    init() {
        Task {
            await setupScene()
        }
    }
    
    private func setupScene() async {
        let scene = SCNScene()
        scene.isPaused = false
        
        setupLighting(in: scene)
        setupEarth(in: scene)
        await setupOcean(in: scene)
        await setupMoon(in: scene)
        setupSun(in: scene)
        await setupCamera(in: scene)
        
        self.scene = scene
        
    }
    
    private func setupLighting(in scene: SCNScene) {
        if let spaceEnvironment = UIImage(named: "space") {
            scene.background.contents = spaceEnvironment
            scene.lightingEnvironment.contents = spaceEnvironment
            scene.lightingEnvironment.intensity = 1.0
        }
    }
    
    private func setupEarth(in scene: SCNScene) {
        let earthGeometry = SCNSphere(radius: earthRadius)
        let earthMaterial = SCNMaterial()
        
        if let earthTexture = UIImage(named: "earth_texture") {
            earthMaterial.diffuse.contents = earthTexture
        } else {
            earthMaterial.diffuse.contents = UIColor.blue
        }
        
        earthGeometry.materials = [earthMaterial]
        earthNode.geometry = earthGeometry
        scene.rootNode.addChildNode(earthNode)
        
        // rotate earth
        let action = SCNAction.rotate(by: 360*CGFloat(M_PI/180), around: SCNVector3(0, 1, 0), duration: 8)
        earthNode.runAction(SCNAction.repeatForever(action))
        
    }
    
    private func setupOcean(in scene: SCNScene) async {
        await updateOceanGeometry()
        scene.rootNode.addChildNode(oceanNode)
    }
    
    private func setupMoon(in scene: SCNScene) async {
        let moonGeometry = SCNSphere(radius: moonRadius)
        let moonMaterial = SCNMaterial()
        
        if let moonTexture = UIImage(named: "moon_texture") {
            moonMaterial.diffuse.contents = moonTexture
        } else {
            moonMaterial.diffuse.contents = UIColor.gray
        }
        
        moonGeometry.materials = [moonMaterial]
        moonNode.geometry = moonGeometry
       
        scene.rootNode.addChildNode(moonNode)
        
        await MainActor.run {
            let action = SCNAction.rotate(by: 360*CGFloat(M_PI/180), around: SCNVector3(x: 0, y: 1, z: 0), duration: 218)
            moonNode.runAction(SCNAction.repeatForever(action))
        }
        
        await updateMoonPosition()
    }
    
    private func setupSun(in scene: SCNScene) {
        let sunGeometry = SCNSphere(radius: sunRadius)
        let sunMaterial = SCNMaterial()
        
        if let sunTexture = UIImage(named: "sun_texture") {
            sunMaterial.diffuse.contents = sunTexture
            sunMaterial.emission.contents = sunTexture
        } else {
            sunMaterial.diffuse.contents = UIColor.yellow
            sunMaterial.emission.contents = UIColor.yellow
        }
        
        sunGeometry.materials = [sunMaterial]
        sunNode.geometry = sunGeometry
        sunNode.position = SCNVector3(sunDistance, 0, 0)
        
        // Add tilted rotation to sun (7.25 degrees)
        let tiltedAxis = SCNVector3(0, cos(7.25 * .pi / 180), sin(7.25 * .pi / 180))
        
        // Sun's equatorial rotation (24 days = 192 seconds in our scale where Earth = 8 seconds)
        let rotationAction = SCNAction.rotate(by: 360 * CGFloat(Double.pi / 180), 
                                            around: tiltedAxis, 
                                            duration: 192)
        sunNode.runAction(SCNAction.repeatForever(rotationAction))
        
        let glowNode = createEnhancedSunGlow()
        sunNode.addChildNode(glowNode)
        
        scene.rootNode.addChildNode(sunNode)
    }
    
    private func createEnhancedSunGlow() -> SCNNode {
        let glowGeometry = SCNSphere(radius: sunRadius * 1.2)
        let glowMaterial = SCNMaterial()
        glowMaterial.diffuse.contents = UIColor.clear
        glowMaterial.emission.contents = UIColor.yellow.withAlphaComponent(0.3)
        glowGeometry.materials = [glowMaterial]
        return SCNNode(geometry: glowGeometry)
    }
    
    private func setupCamera(in scene: SCNScene) async {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 3)
        scene.rootNode.addChildNode(cameraNode)
        
        self.scene = scene
    }
    
    private func calculateTidalForce(distance: Double, mass: Double) -> Double {
        return (G * mass * realEarthRadius) / pow(distance, 3)
    }
    
    func updateTideHeight(for tideType: TideType) async {
        let scaledMoonDistance = realMoonDistance * (moonDistance / 1.5)
        let moonTidalForce = calculateTidalForce(distance: scaledMoonDistance, mass: moonMass)
        let sunTidalForce = calculateTidalForce(distance: realSunDistance, mass: sunMass)
        
        var totalTidalForce = moonTidalForce
        
        switch tideType {
        case .spring:
            let angle = moonOrbitAngle * .pi / 180
            let alignmentFactor = cos(angle)
            // Increase spring tide effect
            totalTidalForce += sunTidalForce * abs(alignmentFactor) * 1.5
            
        case .neap:
            let angle = moonOrbitAngle * .pi / 180
            let cancellationFactor = sin(angle)
            // Reduce neap tide effect
            totalTidalForce -= sunTidalForce * abs(cancellationFactor) * 0.8
            
        case .low:
            // Further reduce low tide effect
            totalTidalForce *= 0.5
            
        case .normal:
            // Normal tide - just moon's influence
            totalTidalForce *= 0.7
        }
        
        let maxForce = calculateTidalForce(distance: realMoonDistance, mass: moonMass) * 2
        let normalizedForce = totalTidalForce / maxForce
        
        // Adjust base height and range for more realistic values
        tideHeight = 0.1 + (normalizedForce * 0.3)
        
        await updateOceanGeometry()
    }
    
    func updateMoonPosition() async {
        let angle = moonOrbitAngle * .pi / 180
        let x = moonDistance * cos(angle)
        let z = moonDistance * sin(angle)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.016
        moonNode.position = SCNVector3(x, 0, z)
        SCNTransaction.commit()
        
        await updateTideHeight(for: tideType)
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        
        Task { @MainActor in
            isAnimating = true
            
            // Use async/await pattern for animation
            while isAnimating {
                moonOrbitAngle = (moonOrbitAngle + 0.2).truncatingRemainder(dividingBy: 360)
                await updateMoonPosition()
                try? await Task.sleep(nanoseconds: 16_666_667) // ~60fps
            }
        }
    }
    
    func stopAnimation() {
        Task { @MainActor in
            isAnimating = false
        }
    }
    
    private func updateOceanGeometry() async {
        guard !Task.isCancelled else { return }
        
        let angle = moonOrbitAngle * .pi / 180
        let bulgeDirection = SCNVector3(cos(angle), 0, sin(angle))
        let newGeometry = createTidalSphere(radius: earthRadius + tideHeight, bulgeDirection: bulgeDirection)
        
        await MainActor.run {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.016
            oceanNode.geometry = newGeometry
            SCNTransaction.commit()
        }
    }
    
    private func createTidalSphere(radius: Double, bulgeDirection: SCNVector3) -> SCNGeometry {
        #if targetEnvironment(simulator)
        let segments = 48
        #else
        let segments = 64
        #endif
        
        var vertices: [SCNVector3] = []
        var indices: [UInt32] = []
        var colors: [CGColor] = []
        var normals: [SCNVector3] = []
        
        for i in 0...segments {
            let lat = Double(i) * .pi / Double(segments)
            for j in 0...segments {
                let lon = Double(j) * 2 * .pi / Double(segments)
                
                var x = radius * sin(lat) * cos(lon)
                var y = radius * sin(lat) * sin(lon)
                var z = radius * cos(lat)
                
                let point = SCNVector3(x, y, z)
                let dotProduct = dot(normalize(point), normalize(bulgeDirection))
                let bulgeAmount = tideHeight * (dotProduct + 1) / 1.8
                
                let bulgeMultiplier = 1.0 + bulgeAmount * (1.2 + abs(dotProduct))
                x *= bulgeMultiplier
                y *= bulgeMultiplier
                z *= bulgeMultiplier
                
                let vertex = SCNVector3(x, y, z)
                vertices.append(vertex)
                normals.append(normalize(vertex))
                
                let colorIntensity = CGFloat((bulgeMultiplier - 1.0) / tideHeight)
                let tideColor = UIColor(red: 0.0,
                                      green: 0.4 + colorIntensity * 0.3,
                                      blue: 1.0,
                                      alpha: 0.6)
                colors.append(tideColor.cgColor)
            }
        }
        
        for i in 0..<segments {
            for j in 0..<segments {
                let row1 = i * (segments + 1)
                let row2 = (i + 1) * (segments + 1)
                
                indices.append(UInt32(row1 + j))
                indices.append(UInt32(row2 + j + 1))
                indices.append(UInt32(row1 + j + 1))
                
                indices.append(UInt32(row1 + j))
                indices.append(UInt32(row2 + j))
                indices.append(UInt32(row2 + j + 1))
            }
        }
        
        let vertexSource = SCNGeometrySource(vertices: vertices)
        let normalSource = SCNGeometrySource(normals: normals)
        let colorSource = SCNGeometrySource(data: Data(bytes: colors, count: colors.count * MemoryLayout<CGColor>.size),
                                          semantic: .color,
                                          vectorCount: colors.count,
                                          usesFloatComponents: true,
                                          componentsPerVector: 4,
                                          bytesPerComponent: MemoryLayout<Float>.size,
                                          dataOffset: 0,
                                          dataStride: MemoryLayout<CGColor>.stride)
        
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        
        let geometry = SCNGeometry(sources: [vertexSource, normalSource, colorSource], elements: [element])
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 0.0, green: 0.4, blue: 1.0, alpha: 0.6)
        material.specular.contents = UIColor.white
        material.specular.intensity = 1.0
        material.metalness.contents = 0.8
        material.roughness.contents = 0.2
        material.fresnelExponent = 1.5
        material.lightingModel = .physicallyBased
        material.transparent.contents = UIColor(white: 1.0, alpha: 0.7)
        
        geometry.materials = [material]
        return geometry
    }
    
    private func dot(_ v1: SCNVector3, _ v2: SCNVector3) -> Double {
        return Double(v1.x * v2.x + v1.y * v2.y + v1.z * v2.z)
    }
    
    private func normalize(_ v: SCNVector3) -> SCNVector3 {
        let length = sqrt(Double(v.x * v.x + v.y * v.y + v.z * v.z))
        return SCNVector3(v.x / Float(length), v.y / Float(length), v.z / Float(length))
    }
    
    func positionForTideType(_ newTideType: TideType) {
        stopAnimation()
        tideType = newTideType
        
        switch newTideType {
        case .spring:
            moonOrbitAngle = 0
            moonDistance = 1.5
        case .neap:
            moonOrbitAngle = 90
            moonDistance = 1.5
        case .low:
            moonOrbitAngle = 45
            moonDistance = 3.0
        case .normal:
            moonOrbitAngle = 45
            moonDistance = 1.5
        }
        
        Task {
            await updateMoonPosition()
            await updateTideHeight(for: tideType)
        }
    }
}

extension SCNGeometry {
    class func line(from: SCNVector3, to: SCNVector3) -> SCNGeometry {
        let vertices: [SCNVector3] = [from, to]
        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: [0, 1], primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
} 
