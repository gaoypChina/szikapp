# SZIKapp

SZIK projekt a 2020/21-es tanév őszi félévében.

[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
![develop](https://github.com/csertant/szikapp/workflows/test/badge.svg?branch=develop)
![master](https://github.com/csertant/szikapp/workflows/build%20&%20deploy/badge.svg?branch=master)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/csertant/szikapp)
![GitHub](https://img.shields.io/github/license/csertant/szikapp)

## Kezdő lépések

- Ha nincs telepítve a [git](https://git-scm.com/downloads) a számítógépeden, tedd meg
- Töltsd le és telepítsd a [flutter](https://flutter.dev/docs/get-started/install/windows)-t
- Tölts le és telepíts egy IDE-t (Visual Studio Code vagy Android Studio), [konfiguráld](https://flutter.dev/docs/get-started/editor) hozzá a flutter-t
- Klónozd le ezt a repository-t: ```git clone https://github.com/csertant/szikapp.git```
- Futtasd a ```flutter pub get``` parancsot a függőségek feloldásához
- Csatlakoztasd a telefonod a számítógéphez vagy indíts egy új Phone Emulatort
- Nyomd meg az F5-öt az app futtatásához

## Fejlesztői parancsok

- ```flutter pub run build_runner build```: elkészíti a legenerálandó forráskódfájlokat
- ```flutter build appbundle```: elkészíti a Google Play Storeba feltölthető Appbundle fájlt
- ```flutter build apk```: elkészíti az androidos telefonra telepíthető APK-t
- ```flutter run```: elkészíti és futtatja az Appot egy megfelelő eszközön
