import Foundation
import Hokusai
import HokusaiNIO
import NIOCore

extension Example {
    static let nioBuffers = Example("nio.buffers") {
        // snippet: nio.buffers
        let bytes = try Data(contentsOf: URL(fileURLWithPath: "scene.png"))
        var buffer = ByteBuffer(bytes: bytes)

        // A ByteBuffer in: the readable bytes are adopted, so the buffer may be reused or released at once.
        let image = try Hokusai(buffer: buffer)
        buffer.clear()

        // A ByteBuffer out, all at once...
        let whole = try await image.resize(width: 400).webp().byteBuffer()
        print("byteBuffer:", whole.buffer.readableBytes, "bytes,", whole.info.width, "×", whole.info.height)

        // ...or streamed, one buffer at a time, with the backpressure of writeChunks.
        var received = 0, count = 0
        let info = try await image.resize(width: 400).jpeg().writeByteBuffers(chunkSize: 4096) { chunk in
            received += chunk.readableBytes
            count += 1
        }
        print("writeByteBuffers:", count, "buffers,", received, "bytes; info says", info.byteCount)

        // Output.byteBuffer wraps bytes you already have in a fresh buffer.
        let output = try await image.resize(width: 100).png().data()
        print("Output.byteBuffer:", output.byteBuffer.readableBytes, "bytes")
        // endsnippet
    }
}
