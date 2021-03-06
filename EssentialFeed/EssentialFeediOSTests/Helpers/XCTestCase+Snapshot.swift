//
//  XCTestCase+Snapshot.swift
//  EssentialFeediOSTests
//
//  Created by Genrikh Beraylik on 10.05.2022.
//

import XCTest

extension XCTestCase {
    func assert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotData = makeSnapshotData(snapshot: snapshot, file: file, line: line)
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        
        guard let storedSnapshotData = try? Data.init(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting", file: file, line: line)
            return
        }
        
        if snapshotData != storedSnapshotData {
            let temprorarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(snapshotURL.lastPathComponent)
            
            try? snapshotData?.write(to: temprorarySnapshotURL)
            
            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temprorarySnapshotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    
    }
    
    func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotData = makeSnapshotData(snapshot: snapshot, file: file, line: line)
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true)
            
            try snapshotData?.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        return URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshot")
            .appendingPathComponent("\(name).png")
    }
    
    private func makeSnapshotData(snapshot: UIImage, file: StaticString = #file, line: UInt = #line) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        return data
    }
}
