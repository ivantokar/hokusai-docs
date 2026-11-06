import Foundation
import Hokusai

// A minimal check that the container has a working Hokusai runtime: report the native versions,
// then resize a generated image and encode it as WebP.
let capabilities = try Hokusai.capabilities()
print("libvips \(capabilities.libvipsVersion), Cairo \(capabilities.cairoVersion)")
print("can write: \(capabilities.outputFormats.map(\.rawValue).sorted().joined(separator: ", "))")

let pixels = Data((0..<(64 * 64 * 3)).map { UInt8($0 % 251) })
let output = try await Hokusai(raw: pixels, width: 64, height: 64, format: .rgb8)
    .resize(width: 32)
    .webp(quality: 80)
    .data()
print("resized to \(output.info.width) × \(output.info.height), \(output.info.byteCount) bytes (\(output.info.format.rawValue))")
