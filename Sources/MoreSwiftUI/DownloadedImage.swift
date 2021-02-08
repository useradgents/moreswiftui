import Foundation
import Slab
import Combine
import SwiftUI

public class ImageDownloader: ObservableObject {
    @Published public var path: URL?
    @Published public var error: Error?
    private let url: URL
    
    private var task: URLSessionDownloadTask?
    
    public init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancel()
    }
    
    public func load() {
        let filename = "\(url.absoluteString.sha1()).\(url.pathExtension)"
        
        let localPath: URL
        do {
            let cacheDir = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let imageDir = cacheDir.appendingPathComponent("imageDownloader.cache")
            if !FileManager.default.fileExists(atPath: imageDir.path) {
                try FileManager.default.createDirectory(at: imageDir, withIntermediateDirectories: true, attributes: nil)
            }
            
            localPath = imageDir.appendingPathComponent(filename)
        }
        catch {
            print("\(url.absoluteString) fail compute local path")
            self.error = URLError(.unknown)
            return
        }
        
        if FileManager.default.fileExists(atPath: localPath.path) {
            print("\(url.absoluteString) is already downloaded at \(localPath.path)")
            self.path = localPath
            return
        }
        
        task = URLSession.shared.downloadTask(with: url, completionHandler: { (path, response, error) in
            
            if let e = error {
                DispatchQueue.main.async {
                    print("\(self.url.absoluteString) download error \(e.localizedDescription)")
                    self.error = e
                }
                return
            }
            
            guard let p = path else {
                DispatchQueue.main.async {
                    print("\(self.url.absoluteString) no download path")
                    self.error = URLError(.unknown)
                }
                return
            }
            
            
            do {
                try FileManager.default.moveItem(at: p, to: localPath)
            }
            catch {
                DispatchQueue.main.async {
                    print("\(self.url.absoluteString) cannot move from \(p.path) to \(localPath.path)")
                    self.error = URLError(.unknown)
                }
                return
            }
            
            DispatchQueue.main.async {
                print("\(self.url.absoluteString) has been downloaded to \(localPath.path)")
                self.path = localPath
            }
        })
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
        task = nil
    }
}

public struct DownloadedImage<PlaceholderView: View, ErrorView: View>: View {
    @StateObject private var downloader: ImageDownloader
    private let placeholder: () -> PlaceholderView
    private let errorView: (Error) -> ErrorView
    
    public init(url: URL, @ViewBuilder placeholder: @escaping () -> PlaceholderView, @ViewBuilder errorView: @escaping (Error) -> ErrorView) {
        self.placeholder = placeholder
        self.errorView = errorView
        _downloader = StateObject(wrappedValue: ImageDownloader(url: url))
    }
    
    public var body: some View {
        Group {
            if let path = downloader.path, let img = UIImage(contentsOfFile: path.path) {
                Image(uiImage: img).resizable()
            }
            else if let e = downloader.error {
                errorView(e).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                placeholder().frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear(perform: downloader.load)
            }
        }
    }
}
