/*
 * *
 *  * Created by Udith Perera on 12/21/23, 3:54 PM
 *  * Copyright (c) 2023 . All rights reserved.
 *  * Last modified 12/21/23, 3:54 PM
 *
 */

import Darwin
import MachO
import UIKit

@objc public class OneRoot: NSObject {
    @objc public static var isJailbroken: String {
        do {
           for result in OneRoot.factResult {
              if result {
                  return "ROOTED"
              }
            }
          return ""
        } catch {
            return ""
        }

    }

    @objc public static var factResult: [Bool] {
        let jailresults: [Bool] = {
            var results: [Bool] = []
            results.append(OneRoot.isSandbox())
            results.append(OneRoot.isDangerousFiles())
            results.append(OneRoot.isDYLD())
            results.append(OneRoot.isFork())
            results.append(OneRoot.isDangerousDir())
            results.append(OneRoot.isDangerousLinks())
            return results
        }()
        return jailresults
    }

    @objc public static func isSandbox() -> Bool {
        let stringToWrite = "You are in Debug or Sanbox Env"
        do {
            try stringToWrite.write(toFile:"/private/debug.txt", atomically:true, encoding:String.Encoding.utf8)
            return true
        } catch {
            return false
        }
    }

    @objc public static func isDangerousFiles() -> Bool {
        guard TARGET_IPHONE_SIMULATOR != 1 else { return false }
        let paths = [
            "/usr/sbin/frida-server", // frida
            "/etc/apt/sources.list.d/electra.list", // electra
            "/etc/apt/sources.list.d/sileo.sources", // electra
            "/.bootstrapped_electra", // electra
            "/usr/lib/libjailbreak.dylib", // electra
            "/jb/lzma", // electra
            "/.cydia_no_stash", // unc0ver
            "/.installed_unc0ver", // unc0ver
            "/jb/offsets.plist", // unc0ver
            "/usr/share/jailbreak/injectme.plist", // unc0ver
            "/etc/apt/undecimus/undecimus.list", // unc0ver
            "/var/lib/dpkg/info/mobilesubstrate.md5sums", // unc0ver
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/jb/jailbreakd.plist", // unc0ver
            "/jb/amfid_payload.dylib", // unc0ver
            "/jb/libjailbreak.dylib", // unc0ver
            "/usr/libexec/cydia/firmware.sh",
            "/Applications/Cydia.app",
            "/Applications/FakeCarrier.app",
            "/Applications/Icy.app",
            "/Applications/IntelliScreen.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/SBSettings.app",
            "/Applications/WinterBoard.app",
            "/Applications/blackra1n.app",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/Library/MobileSubstrate/CydiaSubstrate.dylib",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/bin/bash",
            "/bin/sh",
            "/etc/apt",
            "/etc/ssh/sshd_config",
            "/var/log/apt",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/Users/",
            "/private/var/lib/apt",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/private/var/stash",
            "/private/var/tmp/cydia.log",
            "/private/var/cache/apt/",
            "/private/var/log/syslog",
            "/var/tmp/cydia.log",
            "/usr/bin/sshd",
            "/usr/libexec/sftp-server",
            "/usr/libexec/ssh-keysign",
            "/usr/sbin/sshd",
            "/var/cache/apt",
            "/var/lib/apt",
            "/var/lib/cydia",
            "/usr/sbin/frida-server",
            "/usr/bin/cycript",
            "/usr/local/bin/cycript",
            "/usr/lib/libcycript.dylib",
            "/var/log/syslog",
        ]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    @objc public static func isDangerousLinks() -> Bool {
        let urlSchemes = [
            "undecimus://",
            "cydia://",
            "sileo://",
            "zbra://"
        ]
        for scheme in urlSchemes {
            if (UIApplication.shared.canOpenURL(URL(string: scheme)!)) {
                return true
            }
        }
        return false
    }

    public static func isFork() -> Bool {
        let pointerToFork = UnsafeMutableRawPointer(bitPattern: -2)
        let forkPtr = dlsym(pointerToFork, "fork")
        typealias ForkType = @convention(c) () -> pid_t
        let fork = unsafeBitCast(forkPtr, to: ForkType.self)
        let forkResult = fork()
        if forkResult >= 0 {
            if forkResult > 0 {
                kill(forkResult, SIGTERM)
            }
            if(!isSimulator()) {
                return true
            }
        }
        return false
    }

    @objc public static func isDYLD() -> Bool {
        let suspiciousLibraries = [
            "SubstrateLoader.dylib",
            "SSLKillSwitch2.dylib",
            "SSLKillSwitch.dylib",
            "MobileSubstrate.dylib",
            "TweakInject.dylib",
            "CydiaSubstrate",
            "cynject",
            "CustomWidgetIcons",
            "PreferenceLoader",
            "RocketBootstrap",
            "WeeLoader",
            "/.file"
        ]
        for libraryIndex in 0..<_dyld_image_count() {
            guard let loadedLibrary = String(validatingUTF8: _dyld_get_image_name(libraryIndex)) else { continue }
            for suspiciousLibrary in suspiciousLibraries {
                if loadedLibrary.lowercased().contains(suspiciousLibrary.lowercased()) {
                    return true
                }
            }
        }
        return false
    }

    private static func isDangerousDir() -> Bool {
        let paths = [
            "/var/lib/undecimus/apt", // unc0ver
            "/Applications",
            "/Library/Ringtones",
            "/Library/Wallpaper",
            "/usr/arm-apple-darwin9",
            "/usr/include",
            "/usr/libexec",
            "/usr/share"
        ]
        for path in paths {
            do {
                let result = try FileManager.default.destinationOfSymbolicLink(atPath: path)
                if !result.isEmpty {
                    return true
                }
            } catch let error {}
        }
        return false
    }

     private static func runtime() -> Bool {
            if(ProcessInfo().environment["SIMULATOR_DEVICE_NAME"] != nil) {
                return true
            }
            return false
     }

    private static func buildphase() -> Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    @objc public static func isSimulator() -> Bool {
        return buildphase() || runtime()
    }
}