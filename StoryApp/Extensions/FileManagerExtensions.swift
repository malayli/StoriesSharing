import Foundation

extension FileManager {
    func url(for fileName: String) -> URL {
        urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
}
