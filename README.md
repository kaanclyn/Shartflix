# Shartflix

Shartflix, Flutter ile geliştirilmiş modern ve çok dilli (Türkçe / İngilizce) bir mobil film uygulamasıdır.  
Bu proje, Flutter bilgimi, kullanıcı arayüzü yaklaşımımı ve uygulama mimarisi konusundaki tercihleri göstermek amacıyla hazırlanmış bir case çalışmasıdır.

---

## Genel Özellikler

- Türkçe ve İngilizce dil desteği
- Dil tercihi uygulama genelinde kalıcı olarak saklanır
- Modern ve sade kullanıcı arayüzü
- Flutter ile cross-platform mimari
- Mock / Backend veri geçişine uygun yapı
- Kolay kurulum ve çalıştırma

---

## Gereksinimler

- Flutter SDK (3.x)
- Flutter `bin` dizininin sistem PATH değişkenine eklenmiş olması
- Android SDK / Platform Tools  
  (Android cihaz veya emülatör için)

---

## Flutter Kurulumu (Windows / PowerShell)

```powershell
# Flutter kurulu değilse (opsiyonel)
winget install -e --id Flutter.Flutter --silent

# PATH'e ekle
$env:Path += ";C:\Program Files\Flutter\bin;C:\src\flutter\bin"

# Kurulumu doğrula
flutter --version

---

# Uygulama Davranışı
	•	Dil tercihi ilk açılışta otomatik olarak yüklenir
	•	Android için internet izni Manifest dosyasına eklenmiştir
	•	Ana ekran üzerinden mock veya backend veri kaynağına geçiş yapılabilir

---

# Android Yayın Alma
flutter build apk --release

---

## Sorun Giderme

# Flutter komutu bulunamıyor
	•	PowerShell oturumunu kapatıp tekrar açın
	•	Flutter bin dizininin PATH’e eklendiğinden emin olun

---

# Bağımlılık sorunları
flutter clean
flutter pub get

---

# Cihaz görünmüyor
adb devices
•	Emülatörün çalıştığından veya USB hata ayıklamanın açık olduğundan emin olun

---

## Not

Bu proje, teknik yetkinlikleri ve Flutter geliştirme yaklaşımını göstermek amacıyla hazırlanmış bir case çalışmasıdır.