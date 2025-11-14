# NGROK Kurulum ve Yapılandırma Kılavuzu

> **Türkçe** | [Click here for English version](README.md)

Ubuntu ve Termux ortamları için otomatik ngrok kurulum scripti.

## İçindekiler

- [Özellikler](#özellikler)
- [Gereksinimler](#gereksinimler)
- [Kurulum](#kurulum)
- [NGROK Yapılandırması](#ngrok-yapılandırması)
- [Kullanım Örnekleri](#kullanım-örnekleri)
- [Sorun Giderme](#sorun-giderme)
- [Gelişmiş Yapılandırma](#gelişmiş-yapılandırma)

## Özellikler

- Otomatik sudo tespiti (sudo olan ve olmayan sistemlerde çalışır)
- Mimari otomatik algılama (amd64, arm64, arm, 386)
- Termux ve Ubuntu desteği
- Akıllı kurulum dizini seçimi
- Hata yönetimi ve bilgilendirici mesajlar
- Temizlik ve doğrulama adımları

## Gereksinimler

### Ubuntu/Debian Sistemler
- Bash shell
- İnternet bağlantısı
- (İsteğe bağlı) sudo erişimi

### Termux
- İnternet bağlantısı
- Termux uygulaması (Android)

## Tek Komutla Otomatik Kurulum

```bash
sudo apt install -y wget && wget -O - https://raw.githubusercontent.com/ozbilgic/install-ngrok-on-ubuntu-in-termux/main/ngrok-installer.sh | bash
```

## Manuel Kurulum

### Adım 1: Script'i İndirin

```bash
# Git ile (önerilir)
git clone https://github.com/ozbilgic/install-ngrok-on-ubuntu-in-termux.git
cd install-ngrok-on-ubuntu-in-termux

# veya wget ile
wget https://raw.githubusercontent.com/ozbilgic/install-ngrok-on-ubuntu-in-termux/main/ngrok-installer.sh
chmod +x ngrok-installer.sh
```

### Adım 2: Script'i Çalıştırın

```bash
bash ngrok-installer.sh
```

Script otomatik olarak:
1. Sisteminizin mimarisini tespit eder
2. Sudo gereksinimini kontrol eder
3. Uygun kurulum dizinini seçer
4. ngrok'u indirir ve kurar
5. Kurulumu doğrular

### Kurulum Dizinleri

Script aşağıdaki sırayla kurulum dizini seçer:

1. **Termux**: `$PREFIX/bin` (genellikle `/data/data/com.termux/files/usr/bin`)
2. **Sudo ile sistem**: `/usr/local/bin`
3. **Sudo olmadan**: `~/.local/bin`
4. **Yedek**: `~/bin`

## NGROK Yapılandırması

### 1. Hesap Oluşturma

ngrok kullanmak için ücretsiz bir hesap oluşturmanız gerekir:

1. [ngrok.com/signup](https://dashboard.ngrok.com/signup) adresine gidin
2. Hesap oluşturun (ücretsiz)
3. Email adresinizi doğrulayın

### 2. Authtoken Alma

Dashboard'dan authtoken'ınızı alın:

```
https://dashboard.ngrok.com/get-started/your-authtoken
```

### 3. Authtoken Yapılandırması

Authtoken'ı ngrok'a ekleyin:

```bash
ngrok config add-authtoken YOUR_AUTHTOKEN_HERE
```

Örnek:
```bash
ngrok config add-authtoken 2abc3def4ghi5jkl6mno7pqr8stu9vwx
```

Bu komut authtoken'ı şu konuma kaydeder:
- **Linux/Termux**: `~/.config/ngrok/ngrok.yml`
- **MacOS**: `~/Library/Application Support/ngrok/ngrok.yml`

### 4. Yapılandırma Dosyasını Düzenleme

Gelişmiş yapılandırma için `ngrok.yml` dosyasını düzenleyebilirsiniz:

```bash
# Yapılandırma dosyasının konumunu öğrenme
ngrok config check

# Dosyayı düzenleme
nano ~/.config/ngrok/ngrok.yml
```

Temel yapılandırma örneği:

```yaml
version: "2"
authtoken: YOUR_AUTHTOKEN_HERE
region: us  # us, eu, ap, au, sa, jp, in
tunnels:
  web:
    proto: http
    addr: 8080
  ssh:
    proto: tcp
    addr: 22
```

## Kullanım Örnekleri

### Temel HTTP Tüneli

Yerel web sunucunuzu internete açma:

```bash
# Port 8080'de çalışan sunucu için
ngrok http 8080

# Port 3000'de çalışan React/Node.js sunucusu için
ngrok http 3000

# HTTPS ile
ngrok http https://localhost:8080
```

### Custom Domain ile

```bash
ngrok http --domain=yoursubdomain.ngrok.io 8080
```

### TCP Tüneli

SSH veya diğer TCP servisleri için:

```bash
# SSH için
ngrok tcp 22

# Veritabanı için
ngrok tcp 5432  # PostgreSQL
ngrok tcp 3306  # MySQL
```

### Yapılandırma Dosyasından Tünel Başlatma

```bash
# Tanımlı bir tüneli başlatma
ngrok start web

# Birden fazla tüneli aynı anda başlatma
ngrok start web ssh

# Tüm tünelleri başlatma
ngrok start --all
```

### Kimlik Doğrulama Ekleme

Tünelinize şifre koruması ekleyin:

```bash
ngrok http 8080 --basic-auth "kullanici:sifre"
```

### IP Kısıtlaması

Belirli IP adreslerinden erişime izin verme:

```bash
ngrok http 8080 --cidr-allow 192.168.1.0/24
```

### Request İnceleme

Web arayüzü ile istekleri inceleme:
```
http://127.0.0.1:4040
```

## Sorun Giderme

### ngrok komutu bulunamıyor

PATH'e ekleme:

```bash
# ~/.bashrc veya ~/.zshrc dosyasına ekleyin
export PATH="$HOME/.local/bin:$PATH"

# Değişiklikleri uygulayın
source ~/.bashrc  # veya source ~/.zshrc
```

### Authtoken hatası

Authtoken'ı yeniden yapılandırın:

```bash
ngrok config add-authtoken YOUR_NEW_TOKEN
```

### Bağlantı hatası

1. İnternet bağlantınızı kontrol edin
2. Firewall ayarlarını kontrol edin
3. ngrok'un güncel olduğundan emin olun:

```bash
ngrok update
```

### Port zaten kullanımda

Başka bir port kullanın veya mevcut servisi durdurun:

```bash
# Hangi işlemin portu kullandığını bulma
lsof -i :8080  # Linux/MacOS
netstat -ano | findstr :8080  # Windows

# İşlemi sonlandırma
kill -9 PID
```

### Termux'ta izin sorunları

Depolama iznini verin:

```bash
termux-setup-storage
```

## Gelişmiş Yapılandırma

### Bölge Seçimi

En yakın bölgeyi seçerek gecikmeyi azaltın:

```bash
ngrok config add-region eu  # Avrupa
ngrok config add-region us  # Amerika
ngrok config add-region ap  # Asya-Pasifik
ngrok config add-region au  # Avustralya
ngrok config add-region sa  # Güney Amerika
ngrok config add-region jp  # Japonya
ngrok config add-region in  # Hindistan
```

### Özel Yapılandırma Dosyası

Farklı bir yapılandırma dosyası kullanma:

```bash
ngrok http 8080 --config=/path/to/custom-config.yml
```

### Log Kayıtları

Detaylı log kayıtları için:

```bash
ngrok http 8080 --log=stdout --log-level=debug
```

### Kalıcı Tünel (Paid)

Ücretli hesaplarda özel subdomain kullanımı:

```yaml
tunnels:
  myapp:
    proto: http
    addr: 8080
    subdomain: myapp  # myapp.ngrok.io olarak erişilebilir
```

### TLS Sertifikası Doğrulama

```bash
# TLS doğrulamasını atlama (geliştirme için)
ngrok http https://localhost:8080 --verify=false
```

### Request/Response Header'ları Değiştirme

```yaml
tunnels:
  myapp:
    proto: http
    addr: 8080
    request_header:
      add:
        - "X-Custom-Header: value"
      remove:
        - "X-Remove-This"
    response_header:
      add:
        - "X-Response-Header: value"
```

## Güvenlik Önerileri

1. **Authtoken'ı Paylaşmayın**: Token'ınızı asla herkese açık yerlerde paylaşmayın
2. **Kimlik Doğrulama Kullanın**: Hassas uygulamalar için `--basic-auth` kullanın
3. **IP Kısıtlaması**: Mümkünse `--cidr-allow` ile IP kısıtlaması yapın
4. **HTTPS Kullanın**: Üretim ortamları için her zaman HTTPS kullanın
5. **Tüneli Kapatın**: Kullanmadığınızda tüneli kapatın (Ctrl+C)

## Faydalı Komutlar

```bash
# Sürümü kontrol etme
ngrok version

# Güncel durumu görüntüleme
ngrok api tunnels list

# Yapılandırmayı kontrol etme
ngrok config check

# Yardım
ngrok help

# Belirli bir komut için yardım
ngrok http --help
```

## Kaynaklar

- [Resmi Dokümantasyon](https://ngrok.com/docs)
- [ngrok Dashboard](https://dashboard.ngrok.com)
- [API Referansı](https://ngrok.com/docs/api)
- [Fiyatlandırma](https://ngrok.com/pricing)

## Lisans

Bu kurulum scripti MIT lisansı altında sunulmaktadır. ngrok'un kendi lisans koşulları geçerlidir.

## Katkıda Bulunma

Sorun bildirimleri ve pull request'ler memnuniyetle karşılanır.

---

**Not**: ngrok ücretsiz planda bazı kısıtlamalara sahiptir:
- Sınırlı bağlantı sayısı
- Rastgele subdomain (özel subdomain yok)
- Sınırlı bölge seçeneği

Daha fazla özellik için ücretli planları değerlendirebilirsiniz.
