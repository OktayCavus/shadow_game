# Shadow Blade Rush - Ürün Gereksinimleri Belgesi (PRD)

## 📋 Proje Genel Bakış

**Oyun Adı:** Shadow Blade Rush  
**Tür:** Aksiyon RPG / Arena Hayatta Kalma  
**Platform:** Mobil (iOS/Android), Web  
**Motor:** Flutter Flame  
**Hedef Kitle:** Aksiyon RPG oyunlarını seven mobil oyuncular

### Oyun Açıklaması

Shadow Blade Rush, oyuncuların her yönden gelen düşmanlarla dolu bir arenada yetenekli bir ninja savaşçısını kontrol ettiği hızlı tempolu bir ninja aksiyon oyunudur. Oyuncular düşman dalgalarında hayatta kalmalı, karakterlerini seviye atlatmalı, becerilerini geliştirmeli ve nihai gölge savaşçısı olmak için güçlü ekipmanlar satın almalıdır.

---

## 🎯 Temel Özellikler

### 1. Karakter Sistemi

- [ ] **Ninja Karakter Oluşturma**

  - [ ] Temel ninja sprite tasarımı
  - [ ] Animasyon durumları (boşta, yürüme, saldırı, skill kullanımı, ölüm)
  - [ ] Sağlık sistemi
  - [ ] Hareket kontrolleri (joystick/dokunma)
  - [ ] Karakter istatistikleri (HP, Saldırı, Savunma, Hız)

- [ ] **Karakter Gelişimi**
  - [ ] Deneyim (XP) sistemi
  - [ ] Seviye atlama mekanikleri
  - [ ] Seviye başına stat artışı
  - [ ] Seviye sınırı sistemi (genişletilebilir)

### 2. Savaş Sistemi

- [ ] **Temel Savaş**

  - [ ] Yakın dövüş saldırı sistemi
  - [ ] Saldırı animasyonları
  - [ ] Hasar hesaplama
  - [ ] Vuruş tespiti
  - [ ] Kritik vuruş sistemi
  - [ ] Kombo sistemi

- [ ] **Beceri Sistemi**
  - [ ] 4 Beceri slotu (3 normal + 1 nihai)
  - [ ] Başlangıç becerileri (2 açık)
  - [ ] Beceri açma sistemi (seviye bazlı)
  - [ ] Beceri geliştirme sistemi
  - [ ] Bekleme süresi mekanikleri
  - [ ] Beceriler için Mana/Enerji sistemi

#### Beceri Kategorileri:

- [ ] **Saldırı Becerileri**
  - [ ] Ateş Kılıcı (Alan hasarı)
  - [ ] Gölge Klonu (çoklu saldırılar)
  - [ ] Şimşek Çarpması (tek hedef, yüksek hasar)
- [ ] **Savunma Becerileri**
  - [ ] Gölge Sıçrama (hareketlilik + yenilmezlik çerçeveleri)
  - [ ] Duman Bombası (geçici görünmezlik)
- [ ] **Nihai Beceriler**
  - [ ] Ejder Gazabi (büyük alan hasarı)
  - [ ] Zaman Durdurma (düşmanları dondurma)

### 3. Düşman Sistemi

- [ ] **Düşman Tipleri**

  - [ ] **Yakın Dövüşçüler**

    - [ ] Temel Goblin (düşük HP, hızlı saldırı)
    - [ ] Zırhlı Ork (yüksek HP, yavaş saldırı)
    - [ ] Çılgın Savaşçı (orta HP, çok hızlı saldırı)

  - [ ] **Uzak Saldırıcılar**

    - [ ] Okçu (ok atar)
    - [ ] Tatar Yayı Askeri (yüksek hasar, yavaş yeniden yükleme)
    - [ ] Ninja Fırlatıcı (shuriken atar)

  - [ ] **Büyücüler**

    - [ ] Ateş Büyücüsü (ateş büyüleri)
    - [ ] Buz Sihirbazı (dondurucu saldırılar)
    - [ ] Karanlık Büyücü (lanet büyüleri)

  - [ ] **Özel Düşmanlar**
    - [ ] Şifacı (diğer düşmanları destekler)
    - [ ] Çağırıcı (minyonlar üretir)
    - [ ] Tank (çok yüksek HP, yavaş)

- [ ] **Düşman Mekanikleri**

  - [ ] Oyuncuya AI yol bulma
  - [ ] Farklı hareket hızları
  - [ ] Saldırı desenleri
  - [ ] Sağlık çubukları
  - [ ] Ölüm animasyonları
  - [ ] Düşürme sistemi (altın, eşyalar, sağlık)

- [ ] **Spawn System**
  - [ ] Wave-based spawning
  - [ ] Multiple spawn points around arena
  - [ ] Level-based enemy difficulty
  - [ ] Spawn rate increase over time
  - [ ] Special enemy spawn conditions

### 4. İlerleme Sistemi

- [ ] **Deneyim ve Seviye Atlama**

  - [ ] Düşman öldürmeden XP kazanımı
  - [ ] Seviye atlama ödülleri
  - [ ] Beceri puanı dağıtımı
  - [ ] Stat puanı dağıtımı

- [ ] **Beceri İlerlemesi**
  - [ ] Beceri seviye sistemi (beceri başına 1-10)
  - [ ] Beceri seviyesi ile hasar artışı
  - [ ] Beceri seviyesi ile bekleme süresi azalması
  - [ ] Seviye ile görsel efekt gelişimi

### 5. Ekonomi Sistemi

- [ ] **Para Birimi Sistemi**

  - [ ] Altın paralar (ana para birimi)
  - [ ] Değerli taşlar (premium para birimi)
  - [ ] Beceri parçaları (beceri geliştirme için)

- [ ] **Düşürme Sistemi**

  - [ ] Düşmanlardan altın düşürmesi
  - [ ] Sağlık iksiri düşürmesi
  - [ ] Geçici güç artırıcı düşürmesi
  - [ ] Nadir beceri tomarları
  - [ ] Ekipman düşürmesi

- [ ] **Mağaza Sistemi**
  - [ ] Ekipman mağazası
  - [ ] Silah geliştirmeleri
  - [ ] Zırh setleri
  - [ ] Tüketilebilirler
  - [ ] Beceri geliştirme materyalleri

### 6. Ekipman Sistemi

- [ ] **Silah Tipleri**

  - [ ] Katana (dengeli istatistikler)
  - [ ] İkili Kılıçlar (yüksek saldırı hızı)
  - [ ] Büyük Kılıç (yüksek hasar)
  - [ ] Sihirli Kılıç (büyü hasarı)

- [ ] **Zırh Setleri**

  - [ ] Ninja Kıyafeti (hız bonusu)
  - [ ] Samuray Zırhı (savunma bonusu)
  - [ ] Gölge Ekipmanı (kritik vuruş bonusu)
  - [ ] Mistik Cübbeleri (büyü gücü bonusu)

- [ ] **Ekipman İstatistikleri**
  - [ ] Saldırı gücü artışı
  - [ ] Savunma artışı
  - [ ] Hız modifikasyonu
  - [ ] Özel yetenekler
  - [ ] Set bonusları

---

## 🎮 Oyun Mekanikleri

### Temel Oynanış Döngüsü

- [ ] **Arena Hayatta Kalma**

  - [ ] Dairesel/dikdörtgen arena
  - [ ] Düşman dalgaları
  - [ ] Hayatta kalma zamanlayıcısı
  - [ ] Puan sistemi

- [ ] **Kontroller**
  - [ ] Hareket için sanal joystick
  - [ ] Beceri butonları (4 buton)
  - [ ] Otomatik saldırı seçeneği
  - [ ] Ayarlar menüsü

### Güç Artırıcılar ve Tüketilebilirler

- [ ] **Geçici Güçlendirmeler**

  - [ ] Hız artışı
  - [ ] Hasar artışı
  - [ ] Yenilmezlik
  - [ ] Çifte XP
  - [ ] Altın mıknatısı

- [ ] **Tüketilebilirler**
  - [ ] Sağlık iksiri
  - [ ] Mana iksiri
  - [ ] Beceri sıfırlama tomarları
  - [ ] Deneyim artırıcıları

---

## 🎨 Görsel ve Ses

### Grafikler

- [ ] **Sanat Stili**

  - [ ] 2D pixel art veya modern 2D stil
  - [ ] Canlı efektlerle karanlık ninja teması
  - [ ] Akıcı animasyonlar
  - [ ] Beceriler için partikül efektleri

- [ ] **UI Tasarımı**
  - [ ] Sağlık çubuğu
  - [ ] Beceri bekleme süresi göstergeleri
  - [ ] Mini-harita (isteğe bağlı)
  - [ ] Puan/seviye gösterimi
  - [ ] Mağaza arayüzü
  - [ ] Envanter ekranı

### Ses

- [ ] **Ses Efektleri**

  - [ ] Saldırı sesleri
  - [ ] Beceri kullanım sesleri
  - [ ] Düşman ölüm sesleri
  - [ ] Altın toplama sesleri
  - [ ] Seviye atlama sesi

- [ ] **Müzik**
  - [ ] Arka plan müziği (ninja teması)
  - [ ] Savaş müziği
  - [ ] Menü müziği
  - [ ] Zafer/yenilgi müziği

---

## 💡 Ek Özellikler

### Yaşam Kalitesi

- [ ] **Kayıt Sistemi**

  - [ ] Otomatik ilerleme kaydetme
  - [ ] Bulut kayıt (isteğe bağlı)
  - [ ] Ayar kalıcılığı

- [ ] **Ayarlar**
  - [ ] Ses seviyesi kontrolleri
  - [ ] Grafik kalitesi seçenekleri
  - [ ] Kontrol hassasiyeti
  - [ ] Dil seçenekleri

### Genişletilmiş Özellikler

- [ ] **Başarım Sistemi**

  - [ ] Öldürme sayısı başarımları
  - [ ] Hayatta kalma süresi başarımları
  - [ ] Beceri ustalığı başarımları
  - [ ] Koleksiyon başarımları

- [ ] **Günlük Görevler**

  - [ ] X düşman öldür
  - [ ] X dakika hayatta kal
  - [ ] Becerileri X kez kullan
  - [ ] X altın topla

- [ ] **Lider Tabloları**
  - [ ] Yüksek puan
  - [ ] En uzun hayatta kalma süresi
  - [ ] En çok düşman öldürme
  - [ ] Haftalık yarışmalar

---

## 🔧 Teknik Gereksinimler

### Flutter Flame Kurulumu

- [ ] **Bağımlılıklar**

  - [ ] pubspec.yaml'a flame paketi ekleme
  - [ ] Sesler için flame_audio ekleme
  - [ ] Kayıt verileri için shared_preferences ekleme
  - [ ] Durum yönetimi için provider ekleme

- [ ] **Proje Yapısı**
  - [ ] Bileşenler (oyuncu, düşmanlar, beceriler)
  - [ ] Ekranlar (oyun, menü, mağaza)
  - [ ] Servisler (ses, kayıt, oyun mantığı)
  - [ ] Varlıklar (resimler, sesler, fontlar)

### Performans Optimizasyonu

- [ ] **Bellek Yönetimi**

  - [ ] Sprite önbellekleme
  - [ ] Düşmanlar için nesne havuzu
  - [ ] Verimli çarpışma tespiti
  - [ ] Kare hızı optimizasyonu

- [ ] **Dosya Organizasyonu**
  - [ ] Her bileşen için ayrı dosyalar
  - [ ] Oyun dengesi için sabitler dosyası
  - [ ] Varlık yönetim sistemi

---

## 📱 Platform Değerlendirmeleri

### Mobil Optimizasyonu

- [ ] **Dokunma Kontrolleri**

  - [ ] Duyarlı dokunma alanları
  - [ ] Haptik geri bildirim
  - [ ] Hareket tanıma

- [ ] **Performans**
  - [ ] 60 FPS hedefi
  - [ ] Batarya optimizasyonu
  - [ ] Farklı ekran boyutları desteği
  - [ ] Yönlendirme desteği

### Çapraz Platform

- [ ] **Web Desteği**
  - [ ] Fare ve klavye kontrolleri
  - [ ] Duyarlı tasarım
  - [ ] Tarayıcı uyumluluğu

---

## 🎨 Gerekli Varlıklar

### Sprite'lar ve Animasyonlar

- [ ] **Karakter Varlıkları**

  - [ ] Ninja karakter sprite sayfaları
  - [ ] Beceri efekt animasyonları
  - [ ] Silah sprite'ları
  - [ ] Zırh/kıyafet varyasyonları

- [ ] **Düşman Varlıkları**

  - [ ] Her tip için düşman sprite sayfaları
  - [ ] Ölüm animasyonları
  - [ ] Saldırı animasyonları
  - [ ] Özel efekt sprite'ları

- [ ] **Çevre**
  - [ ] Arena arka planı
  - [ ] Zemin dokular
  - [ ] Partikül efektleri
  - [ ] UI elemanları

### Ses Varlıkları

- [ ] **Ses Efektleri**

  - [ ] Savaş sesleri
  - [ ] Arayüz sesleri
  - [ ] Çevresel sesler
  - [ ] Beceri kullanım sesleri

- [ ] **Müzik Parçaları**
  - [ ] Ana tema
  - [ ] Battle music
  - [ ] Menu music
  - [ ] Victory/defeat themes

---

## 🚀 Geliştirme Aşamaları

### Aşama 1: Temel Altyapı

- [ ] Temel oyun kurulumu
- [ ] Oyuncu karakter hareketi
- [ ] Temel düşman doğması
- [ ] Basit savaş sistemi
- [ ] Temel UI

### Aşama 2: Savaş ve Beceriler

- [ ] Komple beceri sistemi
- [ ] Düşman çeşitliliği
- [ ] Hasar sistemi
- [ ] Görsel efektler
- [ ] Ses entegrasyonu

### Aşama 3: İlerleme

- [ ] Seviye sistemi
- [ ] Ekipman sistemi
- [ ] Mağaza işlevselliği
- [ ] Kayıt/yükleme sistemi
- [ ] Denge ayarlamaları

### Aşama 4: Cilalama ve Özellikler

- [ ] Başarım sistemi
- [ ] Günlük görevler
- [ ] Ek içerik
- [ ] Performans optimizasyonu
- [ ] Test ve hata düzeltmeleri

---

## 📊 Başarı Metrikleri

### Oynanış Metrikleri

- [ ] Ortalama oturum uzunluğu
- [ ] Oyuncu tutma oranı
- [ ] Seviye ilerleme oranı
- [ ] Beceri kullanım istatistikleri
- [ ] Ekonomik denge metrikleri

### Teknik Metrikler

- [ ] Kare hızı tutarlılığı
- [ ] Bellek kullanımı optimizasyonu
- [ ] Yükleme süresi minimizasyonu
- [ ] Çökme oranı minimizasyonu
- [ ] Çapraz platform uyumluluğu

---

## 🎯 Gelecek Genişlemeler

### İçerik Güncellemeleri

- [ ] Yeni düşman tipleri
- [ ] Ek beceriler
- [ ] Yeni ekipmanlar
- [ ] Özel etkinlikler
- [ ] Boss savaşları

### Özellik Genişlemeleri

- [ ] Çok oyunculu mod
- [ ] Lonca sistemi
- [ ] Turnuva modu
- [ ] Hikaye modu
- [ ] Karakter özelleştirme

---

**Belge Sürümü:** 1.0  
**Son Güncelleme:** [Güncel Tarih]  
**Proje Durumu:** Planlama Aşaması

---

_Bu PRD, yaşayan bir belge olarak hizmet eder ve özellikler uygulandıkça ve gereksinimler geliştikçe geliştirme süreci boyunca güncellenecektir._
