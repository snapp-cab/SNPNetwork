//
//  Utilities.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/18/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

public class SNPUtilities {
    public class func clearTempDirectory() {
        
        let fileManager = FileManager.default
        do {
            if #available(iOS 10.0, *) {
                let tmpDirURL = fileManager.temporaryDirectory
                let tmpDirectory = try fileManager.contentsOfDirectory(at: tmpDirURL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
                for file in tmpDirectory {
                    try fileManager.removeItem(at: file)
                }
            } else {
                // Fallback on earlier versions
                let tempURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                do {
                    let tempUrls = try  fileManager.contentsOfDirectory(at: tempURL as URL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
                    for file in tempUrls {
                        try fileManager.removeItem(at: file)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    public class func searchAndDeleteFilesInDocumentsFolder(ext: String) {
        
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let directoryUrls = try  fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            //            let Files = directoryUrls.filter {$0.pathExtension == ext}.map {$0.lastPathComponent}
            //            print(Files)
            for file in directoryUrls {
                try fileManager.removeItem(at: file)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
