import Foundation

class SampleCode {

    func restrictedURLInit() {
        let url1 = URL(string: "https://example.com")
        let url2 = URL.init(string: "https://example.com")
        openURL(.init(string: "https://example.com"))
    }

    func restrictedURLPath() {
        guard let url = URL(string: "https://example.com/path/to/resource") else {
            return
        }

        let pathString = url.path
        print("Path: \(pathString)")

        let uppercasedPath = url.path.uppercased()
        print("Uppercased: \(uppercasedPath)")
    }

    func restrictedStringInitWithData() {
        let data = Data([0x48, 0x65, 0x6C, 0x6C, 0x6F])

        if let string1 = String(data: data, encoding: .utf8) {
            print(string1)
        }

        let string2 = String.init(data: data, encoding: .utf8)
        print(string2 ?? "nil")
    }

    func allowedAPIs() {
        let fileURL = URL(fileURLWithPath: "/tmp/file.txt")
        let string = String("Hello, World!")

        if let url = URL(string: "https://example.com/path") {
            let components = url.pathComponents
            print(components)
        }

        print("File URL: \(fileURL)")
        print("String: \(string)")
    }

    private func openURL(_ url: URL?) {
        guard let url = url else { return }
        print("Opening URL: \(url)")
    }
}
