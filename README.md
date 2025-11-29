
# SiMaRa Mobile

**SiMaRa (Sistem Manajemen Data Religi & Agama)** is a mobile application designed to help prospective brides and grooms book *Suscatin* (Premarital Course) sessions online through the Mobile Application.

### 🧩 Mobile UI Architecture

<p float="left">
  <img width="200" alt="image" src="https://github.com/user-attachments/assets/ed945873-685b-4f4c-adb3-8ced1397cc22" />
  <img width="240" alt="image" src="https://github.com/user-attachments/assets/39ef0b41-6353-4b9b-bedc-7ac0b2e92aa0" />
  <img width="240" alt="image" src="https://github.com/user-attachments/assets/e1c646c5-8d99-44bd-a558-de67a3c94af6" />
  <img width="240" alt="image" src="https://github.com/user-attachments/assets/038abe58-029c-416b-acbe-07c692245a60" />
  <img width="240" alt="image" src="https://github.com/user-attachments/assets/30139b8f-2e7a-4b69-9ba0-4531259f6f7a" />
  <img width="240" alt="image" src="https://github.com/user-attachments/assets/9d0ba4a5-0b10-43dc-8032-9eb0c0c84441" />
  <img width="200" alt="image" src="https://github.com/user-attachments/assets/10704aa8-cbf6-4206-b3d6-a205872ec2fd" />
<img width="240"  alt="image" src="https://github.com/user-attachments/assets/4764a9e1-9bbd-4413-917a-c5f3a72d10c3" />
</p>

### 🚀 Main Feature

- 🔐 **Authentication**
  - Secure Login & Registration system for new and existing users.
- 👤 **Fecth User Profile**
  - Displays personal information retrieved from the database
- 📅 **Consultation Scheduling (Suscatin)**
  - Users can select preferred consultation day and session:
     - Morning Session: 09:00 – 11:00
     - Afternoon Session: 13:00 – 16:00
  - The session will be displayed in the form of a card along with the consultant's name.
- 📃 **Fecth Status & Detail Schedule**
  - View booked schedules along with their current status

### 🧰 Teknologi yang Digunakan

> Built with the tools and technologies:

![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-FC6D26?style=for-the-badge&logo=flutter&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![JSON](https://img.shields.io/badge/JSON-000000?style=for-the-badge&logo=json&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-C62828?style=for-the-badge&logo=yaml&logoColor=white)

### 🛠 Instalasi & Setup Flutter
Jalankan perintah berikut di terminal:

1. Clone the repo
   
   ```bash
   git clone https://github.com/AbidinoNurkhiansyah/simara-mobile-app.git
2. Change directory to project
   
   ```bash
   cd simara-mobile-app
3. Install dependencies
   
   ```bash
   flutter pub get
4. Running Project
   
   ```bash
   flutter run

### ⚙️ Setup Backend (PHP + Laragon\Xampp)
  
1. *Running Laragon/Xampp*
   <p>Make sure Apache & MySQL are running.</p>

2. Change directory to Laragon\WWW\
   
   ```bash
   cd C:\laragon\www\
   
3.  Clone the API Backend repo
   
   ```bash
   git clone https://github.com/AbidinoNurkhiansyah/simara-mobile-app.git
```
4. *Akses API via Browser*
   Default URL:
   
   ```bash
   http://localhost/simara-api/

### 🔗 Connection Flutter to Localhost

1. Setting API address

   - Android Emulator (AVD default):

     Gunakan 10.0.2.2 sebagai pengganti localhost.
     
  - Real Device (HP Android):

    Pastikan HP & PC satu jaringan Wi‑Fi. jalankan perintah ini di terminal

    ```bash
    ipConfig

    ```
    Copy Hasil IPv4 Addressnya.

2. Setting File Service

   Paste API address nya di service

   ```dart
   final baseUrl = "http://192.168.1.10/simara-api/";


### 🗂 Arsitektur Sistem

```base
+-------------------+ HTTP Request +-------------------+ SQL Query +-------------------+ | | -----------------------------> | | -------------------------> | | | Flutter Mobile | | PHP Backend | | MySQL Database | | (Client App) | <----------------------------- | (Laragon/Apache)| <------------------------- | | | | JSON Response | | Data Result | | +-------------------+ +-------------------+ +-------------------+

```


### Alur Data
1. **Flutter App** mengirimkan request (GET/POST) ke endpoint API.  
2. **PHP Backend (Laragon\Xampp)** menerima request, memproses logika bisnis, dan melakukan query ke database.  
3. **MySQL Database** mengembalikan hasil query ke backend.  
4. **PHP Backend** mengirimkan response dalam format JSON ke Flutter App.  
5. **Flutter App** menampilkan data ke UI.

---

### 🔗 Contoh Endpoint
- `http://10.0.2.2/simara-api/api.php` (Android Emulator)  
- `http://192.168.1.10/simara-api/api.php` (Real Device, sesuaikan IP PC)

---

### 🤝 Contributing
Contributions are welcome!  
If you’d like to improve this project, please follow these steps:
1. Fork the repository
2. Create a new branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

---

### 📄 License
This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

### 👤 Contact / Credits
Created by [Abidino Nurkhiansyah](https://github.com/AbidinoNurkhiansyah)  
📧 Email: abidinonurkhiansyah@gmail.com  
Feel free to reach out for collaboration or questions!

   

