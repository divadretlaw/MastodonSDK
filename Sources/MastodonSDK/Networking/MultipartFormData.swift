//
//  MultipartFormData.swift
//  MastodonSwift
//
//  Created by Marcus Kida on 31.10.22.
//

import Foundation

extension Data {
    func createMultipartFormDataBuilder(withBoundary boundary: String) -> MultipartFormDataBuilder? {
        return MultipartFormDataBuilder(data: self, boundary: boundary)
    }
    
    struct MultipartFormDataBuilder {
        private let boundary: String
        private var httpBody = NSMutableData()
        
        private let data: Data
        
        internal init(data: Data, boundary: String) {
            self.data = data
            self.boundary = boundary
        }
        
        func addTextField(named name: String, value: String) -> Self {
            httpBody.append(textFormField(named: name, value: value))
            return self
        }
        
        private func textFormField(named name: String, value: String) -> String {
            """
            --\(boundary)\r
            Content-Disposition: form-data; name=\"\(name)\"\r
            Content-Type: text/plain; charset=UTF-8\r
            \r
            \(value)\r
            """
        }
        
        func addDataField(named name: String, data: Data, mimeType: String) -> Self {
            httpBody.append(dataFormField(named: name, data: data, mimeType: mimeType))
            return self
        }
        
        private func dataFormField(named name: String, data: Data, mimeType: String) -> Data {
            let string = """
            --\(boundary)\r
            Content-Disposition: form-data; name=\"\(name)\"\
            Content-Type: \(mimeType)\r
            \r
            \(data)\r
            """
            
            return Data(string.utf8)
        }
        
        func build() -> Data {
            return httpBody as Data
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        self.append(Data(string.utf8))
    }
}

extension NSMutableData {
    func append(_ string: String) {
        self.append(Data(string.utf8))
    }
}
