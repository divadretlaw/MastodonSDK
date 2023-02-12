import Foundation

extension URL {
    static func fromOptional(string: String?) -> URL? {
        guard let string = string else {
            return nil
        }
        return URL(string: string)
    }
    
    init(staticString: StaticString) {
        self.init(string: "\(staticString)")!
    }
}

extension URLQueryItem {
    public init?(_ name: String, value: String?) {
        guard let value = value else { return nil }
        self.init(name: name, value: value)
    }
}
