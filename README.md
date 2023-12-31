# oneroot

Introducing our innovative root & jailbreak detection plugin called OneRoot, a powerful tool that allows you to check the part of your device security.

## Features

- Android Root Detection
- IOS JailBreak Detection (coming soon)


## Getting started

To use this package, add oneroot as a dependency in your pubspec.yaml file.

## Usage

- On pubspeck.yaml

```
oneroot: ^0.0.3
```

- On Dart Import

```
import 'package:oneroot/oneroot.dart';
```

- On implementation of Root Detection

```
//Method will return "ROOTED" as a string value, if your are running on rooted environment.
final _onerootPlugin = Oneroot();
String platformRootStatus = await _onerootPlugin.getRootChecker();

//Method will return OS version.
String platformRootStatus = await _onerootPlugin.getRootChecker();
```

<table>
  <tr>
    <td>One Root - Android Root Detection</td>
    <td>One Root - IOS JailBreak Detection</td>
  </tr>
  <tr>
    <td width="30%"><img src="https://github.com/udithperera-dev/oneroot/blob/main/on_android.png" alt="date-picker" style="width:150px;"/></td>
    <td width="30%"><img src="https://github.com/udithperera-dev/oneroot/blob/main/on_android.png" alt="date-picker" style="width:150px;"/></td>
  </tr>
 </table>

- See also from Developer

    - [Akurupela Applications](https://akurupela.com)

<p align="center">
      <img src="https://www.akurupela.com/assets/images/images_info/ap_logo.png" width="25px" alt="logo" align="center">
      <img src="https://storage.googleapis.com/cms-storage-bucket/6a07d8a62f4308d2b854.svg" width="100px" alt="logo" align="center">
      <img src="https://pub.dev/static/hash-tihrt5d6/img/pub-dev-logo.svg" width="100px" alt="logo" align="center">
</p>