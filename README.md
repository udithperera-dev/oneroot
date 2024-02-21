# <kbd><img src="https://raw.githubusercontent.com/udithperera-dev/oneroot/e44f9473e69bd669c047d54abdb276d9babc4cdd/logo.png" width="50px" alt="logo" align="center" style="border-radius:50%"></kbd> oneroot

Introducing our innovative root & jailbreak detection plugin called OneRoot, a powerful tool that allows you to check the part of your device security.
#### As per the [<img src="https://mas.owasp.org/assets/logo_circle.png" width="25px" alt="logo" align="center"> OWAPS](https://mas.owasp.org) standard, we have to create a way for programmatic detection.

<table>
  <tr>
    <td>Android</td>
    <td>IOS</td>
  </tr>
  <tr>
    <td width="30%" style="text-align: left;" align="left" valign="top">
      <li> <sub>File Existence Checks</sub></li>
      <li> <sub>Executing Su And Other Commands</sub></li>
      <li> <sub>Checking Running Processes</sub></li>
      <li> <sub>Checking Installed App Packages</sub></li>
      <li> <sub>Checking For Writable Partitions And System Directories</sub></li>
      <li> <sub>Checking The Debuggable Flag In Application info</sub></li>
      <li> <sub>Timer Checks</sub></li>
      <li> <sub>Messing With Jdwp Related Data structures</sub></li>
      <li> <sub>Checking Tracer pid</sub></li>
    </td>
    <td width="30%" style="text-align: center;" align="left" valign="top">
       <li> <sub>File-based Checks</sub></li>
       <li> <sub>Checking File Permissions</sub></li>
       <li> <sub>Checking Protocol Handlers</sub></li>
       <li> <sub>Frida Detection</sub></li>
       <li> <sub>Emulator Detection</sub></li>
    </td>
  </tr>
 </table>

## Features

- Android Root Detection
- IOS JailBreak Detection


## Getting started

To use this package, add oneroot as a dependency in your pubspec.yaml file.

## Usage

- On pubspeck.yaml

```
oneroot: ^0.1.2
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
String platformVersion = await _onerootPlugin.getPlatformVersion();
```

<table>
  <tr>
    <td>One Root - Android Root Detection</td>
    <td>One Root - IOS JailBreak Detection</td>
  </tr>
  <tr>
    <td width="30%" style="text-align: center;" align="left" valign="top"><img src="https://github.com/udithperera-dev/oneroot/raw/d27a4354c1438602856b2acf6a2e210e19b56cf5/on_android.png" alt="root" style="width:250px;"/></td>
    <td width="30%" style="text-align: center;" align="left" valign="top"><img src="https://raw.githubusercontent.com/udithperera-dev/oneroot/6906a0aa1e419ee47af21061ffc39546f643be31/on_ios.png" alt="root" style="width:250px;"/></td>
  </tr>
 </table>

- See also from Developer

  - [Akurupela Applications](https://akurupela.com)

<p align="center">
      <kbd><img src="https://raw.githubusercontent.com/udithperera-dev/oneroot/e44f9473e69bd669c047d54abdb276d9babc4cdd/logo.png" width="25px" alt="logo" align="center"></kbd>
      <kbd><img src="https://www.akurupela.com/assets/images/images_info/ap_logo.png" width="25px" alt="logo" align="center"></kbd>
      <img src="https://storage.googleapis.com/cms-storage-bucket/6a07d8a62f4308d2b854.svg" width="100px" alt="logo" align="center">
      &nbsp;
      <img src="https://pub.dev/static/hash-tihrt5d6/img/pub-dev-logo.svg" width="100px" alt="logo" align="center">
</p>
