
# SadSha Aurora
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)


SadSha Aurora serves as an alternative to Aura Sync for GNU/Linux, offering control over keyboard backlight and charging threshold settings. This utility facilitates configuring battery thresholds and adjusting keyboard backlight color, brightness, and modes.
SadSha Aurora only targets the ASUS TUF audience, if it worked on any other device, it is just a happy coincidence!.

SadSha Aurora provides two modes

- **Mainline** for kernel version 6.1 +
- **Faustus** for kernel version < 6.1

The modes will be auto-selected depending on the kernel version



## Installation

SadSha Aurora stable/beta comes with an AppImage and a debian release.
Find the latest release from [here](https://github.com/fnjlabs-arch/Aurora/releases).

Fedora COPR builds are not yet published for SadSha Aurora — use the AppImage or the .deb/.rpm from Releases for now.

### Mainline Mode

![App Screenshot](https://github.com/fnjlabs-arch/Aurora/blob/beta/metadata/snaps/arscreen_mainline_1.png)

### Faustus Mode

![App Screenshot](https://github.com/fnjlabs-arch/Aurora/blob/beta/metadata/snaps/arsrceen_1.png)

#### Prerequisites

- [faustus module](https://github.com/hackbnw/faustus)
- If the module is not installed, `dkms openssl mokutil git make cmake` are required for the module installation

#### First Run
SadSha Aurora will direct you to the installation screen if the prerequisites are not satisfied on your system.

![App Screenshot](https://github.com/fnjlabs-arch/Aurora/blob/beta/metadata/snaps/arsrceen_2.png)

SadSha Aurora also provides an option to choose the faustus module repo. If the device is compatible with the module but isn't supported officially, you can create your own fork that adds support to your device
(Read the [documentation](https://github.com/hackbnw/faustus) for more information on the process and any potential dangers.)
By default, SadSha Aurora uses [this fork](https://github.com/legacyO7/faustus.git) that adds support for "FA706IH"

![App Screenshot](https://github.com/fnjlabs-arch/Aurora/blob/beta/metadata/snaps/arsrceen_3.png)

Secureboot enabled devices need to enroll MOK


## Command-Line Arguments

```
usage: 
--log          -       enables logging
--version      -       displays app version
--with-root    -       runs with elevated privileges
```

Appimage builds doesnt support ``--with-root`` argument

## Build and Run

##### - Manual

- [Install Flutter SDK](https://docs.flutter.dev/get-started/install/linux)
- Install additional requirements
  `libgtk-3-0 libblkid1 liblzma5`
- Enable linux desktop
  `flutter config --enable-linux-desktop`
- Run code generator
  `dart run build_runner build --delete-conflicting-outputs  `
- Run the project
  `flutter run`
- Build the project
  `flutter build linux`


## [FAQ](./FAQ.md)


## Contributing

Contributions are always welcome!

Feel free to send a PR


## Authors

- [@legacyO7](https://www.github.com/legacyO7)

#### Questions
Please open an issue at https://github.com/fnjlabs-arch/Aurora


## Credits

- [i3](https://github.com/i3) (i3-sensible-terminal)

- [hackbnw](https://github.com/hackbnw) (faustus module)

## Older Versions
- [TUF-Aurora](https://github.com/legacyO7/TUF-Aurora) (abandoned)

