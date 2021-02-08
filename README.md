# szikapp

SZIK projekt a 2020/21-es tanév őszi félévében.

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