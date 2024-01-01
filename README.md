# oneroot

Introducing our innovative root & jailbreak detection plugin called OneRoot, a powerful tool that allows you to check the part of your device security.
#### As per the [<img src="https://mas.owasp.org/assets/logo_circle.png" width="25px" alt="logo" align="center"> OWAPS](https://mas.owasp.org) standard, we have to create a way for programmatic detection.

* File Existence Checks
* Executing Su And Other Commands
* Checking Running Processes
* Checking Installed App Packages
* Checking For Writable Partitions And System Directories
* Checking The Debuggable Flag In Application info
* Timer Checks
* Messing With Jdwp Related Data structures
* Checking Tracer pid

## Features

- Android Root Detection
- IOS JailBreak Detection (coming soon)


## Getting started

To use this package, add oneroot as a dependency in your pubspec.yaml file.

## Usage

- On pubspeck.yaml

```
oneroot: ^0.0.6
```

- On Dart Import

```
import 'package:oneroot/oneroot.dart';
```

- On implementation of Root Detection

```
//init plugin object
final _onerootPlugin = Oneroot();

//Method will return "ROOTED" as a string value if you are running on a rooted environment.
String platformRootStatus = await _onerootPlugin.getRootChecker();

//Method will return the OS version.
String platformVersion = await _onerootPlugin.getRootChecker();
```

<table>
  <tr>
    <td>One Root - Android Root Detection</td>
    <td>One Root - IOS JailBreak Detection</td>
  </tr>
  <tr>
    <td width="30%" style="text-align: center;"><img src="https://github.com/udithperera-dev/oneroot/raw/d27a4354c1438602856b2acf6a2e210e19b56cf5/on_android.png" alt="root" style="width:250px;"/></td>
    <td width="30%" style="text-align: center;"> Coming Soon</td>
  </tr>
 </table>

- See also from Developer

  - [Akurupela Applications](https://akurupela.com)

<p align="center">
      <img src="https://www.akurupela.com/assets/images/images_info/ap_logo.png" width="25px" alt="logo" align="center">
      <img src="https://storage.googleapis.com/cms-storage-bucket/6a07d8a62f4308d2b854.svg" width="100px" alt="logo" align="center">
      <img src="https://pub.dev/static/hash-tihrt5d6/img/pub-dev-logo.svg" width="100px" alt="logo" align="center">
</p>