<img src="./screenshots/gh_logo.png" alt="Logo" title="Logo" align="right" height="100" />

# AnimeTwistFlut

[![Github all releases](https://img.shields.io/github/downloads/simrat39/animetwistflut/total.svg)](https://GitHub.com/simrat39/animetwistflut/releases/) [![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html) [![Discord](https://img.shields.io/discord/220693787213561857.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.com/invite/2k7awVP) [![release](https://img.shields.io/github/release/simrat39/animetwistflut/all.svg)](https://github.com/simrat39/animetwistflut/releases) 

:star: Star us on GitHub — it helps! (not really)

<img src="./screenshots/banner thingy.png" alt="Logo" title="Logo" />

## Official Anime Twist android application
#### Built with flutter. Fast and beautiful.

## Downloading

Grab the latest apk from the assets [here](https://github.com/simrat39/AnimeTwistFlut/releases).

Make sure to select the correct apk while downloading.

<i> For newer phones: </i> <b> app-arm64-v8a-release.apk </b> will work fine. <br/>
<i> For Smart Tvs and older phones: </i> <b> app-armeabi-v7a-release.apk </b> will work fine. <br/>
<i> For other special phones and emulators: </i> <b> app-x86_64-release.apk </b> will be the best bet. <br/>

## Building

This app is built on flutter's dev channel, therefore before compiling, a switch to the dev channel is needed.

    flutter channel dev
    flutter upgrade --force

Anime Twist requires a secret key to be provided or else video streams wont work. We provide the secret key at compile time with the dart-define flag. We can't show the key for obvious reasons, if you need it for serious development of the video player, please contact someone from the dev team.

    flutter pub get
    flutter run --dart-define=KEY='<secret_key>' --release 

## Submitting issues

Any feature requests or bugs can be reported [here](https://github.com/simrat39/AnimeTwistFlut/issues).

Quick guidelines:  
***For bugs:*** Describe the problem and the steps to reproduce it, maybe include some screenshots from the app for reference.  
***For feature requests:*** Describe all of the new features in detail so they can be easily understood and implemented.

## Contributing

Contributions and patches are encouraged and may be submitted by forking this project and submitting a pull request [here](https://github.com/simrat39/AnimeTwistFlut/pulls).

## License 

This project is licensed under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) License. You can read the details here:
- [License](./LICENSE)
