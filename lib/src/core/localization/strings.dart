import 'app_locale.dart';

class S {
  S(this._l);
  final AppLocale _l;

  static S of(AppLocale l) => S(l);

  // String get appTitle merged below

  // Profile
  String get profile => _l == AppLocale.tr ? 'Profil' : 'Profile';
  String get language => _l == AppLocale.tr ? 'Dil' : 'Language';
  String get english => _l == AppLocale.tr ? 'İngilizce' : 'English';
  String get turkish => _l == AppLocale.tr ? 'Türkçe' : 'Turkish';
  String get lastSignIn => _l == AppLocale.tr ? 'Son giriş' : 'Last sign-in';
  String get unknown => _l == AppLocale.tr ? 'Bilinmiyor' : 'Unknown';
  String get rightsReserved => _l == AppLocale.tr ? 'Nodelabs © Tüm hakları saklıdır.' : 'Nodelabs © All rights reserved.';
  String get designByKaan => _l == AppLocale.tr ? 'Tasarım: Kaan Ç.' : 'Design by Kaan Ç.';

  // Language Page
  String get languageTitle => _l == AppLocale.tr ? 'Dil' : 'Language';
  String get selectLanguage => _l == AppLocale.tr ? 'Tercih ettiğin dili seç' : 'Select your preferred language';

  // Favorites Page
  String get noFavorites => _l == AppLocale.tr ? 'Henüz favori yok' : 'No favorites yet';

  // Detail Page
  String get removeFavorite => _l == AppLocale.tr ? 'Favoriden Kaldır?' : 'Remove Favorite?';
  String get removeFavoriteMessage => _l == AppLocale.tr ? 'Bu öğeyi favorilerinizden kaldırmak istiyor musunuz?' : 'Do you want to remove this item from your favorites?';
  String get remove => _l == AppLocale.tr ? 'Kaldır' : 'Remove';
  String get cancel => _l == AppLocale.tr ? 'İptal' : 'Cancel';
  String get addedToFavorites => _l == AppLocale.tr ? 'Favorilere Eklendi' : 'Added to Favorites';
  String get addToFavorites => _l == AppLocale.tr ? 'Favorilere Ekle' : 'Add to Favorites';
  String get watchTrailer => _l == AppLocale.tr ? 'Fragmanı İzle' : 'Watch trailer';

  // Home Page
  String get shartflix => _l == AppLocale.tr ? 'Shartflix' : 'Shartflix';
  String get useLocalData => _l == AppLocale.tr ? 'Yerel Veri Kullan' : 'Use Local Data';
  String get useBackend => _l == AppLocale.tr ? 'Backend Kullan' : 'Use Backend';
  String get useLocalDataTitle => _l == AppLocale.tr ? 'Yerel Veri Kullanılsın mı?' : 'Use Local Data?';
  String get useLocalDataMessage => _l == AppLocale.tr ? 'Backend şu anda film verisi yok.\n\nYerel demo verisine geçmek sonsuz kaydırma özelliğini etkinleştirir: toplam 20 demo film, kaydırırken sayfa başına 5 film yüklenir. Gerçek API\'ye istediğiniz zaman geri dönebilirsiniz.' : 'Backend currently has no movie data.\n\nSwitching to local mock data will enable infinite scroll for demo: 20 mock movies total, loaded 5 per page as you scroll. You can switch back to real API anytime.';
  String get useLocal => _l == AppLocale.tr ? 'Yerel Kullan' : 'Use Local';
  String get switchBackToBackend => _l == AppLocale.tr ? 'Backend\'e Geri Dön?' : 'Switch Back to Backend?';
  String get switchBackMessage => _l == AppLocale.tr ? 'Gerçek API verisine dönmek istiyor musunuz? Backend listesi boşsa, grid sadece demo kartını gösterebilir.' : 'Do you want to return to real API data? If the backend list is empty, the grid may show only the demo card.';
  String get useBackendButton => _l == AppLocale.tr ? 'Backend Kullan' : 'Use Backend';
  String get stayLocal => _l == AppLocale.tr ? 'Yerel Kal' : 'Stay Local';
  String get noMoviesYet => _l == AppLocale.tr ? 'Henüz film yok' : 'No movies yet';
  String get demoMovie => _l == AppLocale.tr ? 'Demo Film' : 'Demo Movie';
  String get failedToLoadMovies => _l == AppLocale.tr ? 'Filmler yüklenemedi' : 'Failed to load movies';

  // Categories
  String get catTrending => _l == AppLocale.tr ? 'Trend' : 'Trending';
  String get catAction => _l == AppLocale.tr ? 'Aksiyon' : 'Action';
  String get catSciFi => _l == AppLocale.tr ? 'Bilim Kurgu' : 'Sci‑Fi';
  String get catDrama => _l == AppLocale.tr ? 'Dram' : 'Drama';
  String get catComedy => _l == AppLocale.tr ? 'Komedi' : 'Comedy';

  // Bottom navigation
  String get navHome => _l == AppLocale.tr ? 'Ana Sayfa' : 'Home';
  String get navFavorites => _l == AppLocale.tr ? 'Favoriler' : 'Favorites';
  String get navProfile => _l == AppLocale.tr ? 'Profil' : 'Profile';

  // Auth Pages
  String get signIn => _l == AppLocale.tr ? 'Giriş Yap' : 'Sign In';
  String get signUp => _l == AppLocale.tr ? 'Kayıt Ol' : 'Sign Up';
  String get email => _l == AppLocale.tr ? 'E-posta' : 'Email';
  String get password => _l == AppLocale.tr ? 'Şifre' : 'Password';
  String get fullName => _l == AppLocale.tr ? 'Ad Soyad' : 'Full Name';
  String get emailRequired => _l == AppLocale.tr ? 'E-posta gerekli' : 'Email is required';
  String get nameRequired => _l == AppLocale.tr ? 'Ad soyad gerekli' : 'Full name is required';
  String get passwordMinLength => _l == AppLocale.tr ? 'En az 6 karakter' : 'At least 6 characters';
  String get loginFailed => _l == AppLocale.tr ? 'Giriş başarısız' : 'Login failed';
  String get signupFailed => _l == AppLocale.tr ? 'Kayıt başarısız' : 'Sign up failed';
  String get noAccount => _l == AppLocale.tr ? 'Hesabınız yok mu? Kayıt olun' : "Don't have an account? Sign up";
  String get haveAccount => _l == AppLocale.tr ? 'Zaten hesabınız var mı? Giriş yapın' : 'Already have an account? Sign in';
  String get nodelabsRights => _l == AppLocale.tr ? 'Nodelabs Tüm hakları saklıdır.' : 'Nodelabs All rights reserved.';
  String get designer => _l == AppLocale.tr ? 'Tasarımcı: Kaan Ç.' : 'Designer: Kaan.C';
  String get loginSuccess => _l == AppLocale.tr ? 'Giriş başarılı' : 'Login successful';
  String get secureRedirect => _l == AppLocale.tr ? 'Güvenli yönlendirme' : 'Secure redirect';
  String get redirectingIn => _l == AppLocale.tr ? 'Yönlendiriliyor' : 'Redirecting';
  String get secondsSuffix => _l == AppLocale.tr ? 'sn' : 's';

  // App
  String get appTitle => _l == AppLocale.tr ? 'Shartflix' : 'Shartflix';
}


