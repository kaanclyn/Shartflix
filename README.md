# Shartflix

Modern, çok dilli (TR/EN) film uygulaması – Flutter.

## Gereksinimler
- Flutter SDK (3.x) kurulu olmalı
- Flutter `bin` dizini PATH'e ekli olmalı
- Android SDK/Platform Tools (Android cihaz/emülatör için)

Kurulum (Windows/PowerShell):
```powershell
# Flutter kurulu değilse (opsiyonel)
winget install -e --id Flutter.Flutter --silent
$env:Path += ";C:\\Program Files\\Flutter\\bin;C:\\src\\flutter\\bin"

# Doğrula
flutter --version
```

## Hızlı Başlangıç
```powershell
cd C:\\Users\\Kaan\\Desktop\\Shartflix\\shartflix

# Temizle ve bağımlılıkları indir
flutter clean
flutter pub get

# Uygulamayı çalıştır
flutter run
```

## Notlar
- Dil tercihi kalıcıdır; ilk açılışta otomatik yüklenir.
- Android internet izni Manifest'e eklenmiştir.
- Mock/Backend veri geçişi Home ekranından yapılabilir (onaylı).

## Yayın Alma (Android)
```powershell
# APK
flutter build apk --release

# Play Store için AAB
flutter build appbundle --release
```

## Sorun Giderme
- PATH bulunamadı: PowerShell oturumunu kapatıp açın veya PATH'e Flutter `bin` ekleyin.
- Bağımlılıklar: `flutter clean && flutter pub get`
- Cihaz görünmüyor: `adb devices`, emülatör veya USB hata ayıklamayı kontrol edin.
