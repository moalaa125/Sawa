# 💬 Sawa Chat

**Sawa** is a real-time chat application built with **Flutter** and **Firebase**, featuring a full authentication flow with email verification and a clean, premium UI.

---

## 📱 Screenshots

| Login | Register | Chat | Verification | Reset Password |
|-------|----------|------|--------------|----------------|
| ![Login](screenshots/login.png) | ![Register](screenshots/register.png) | ![Chat](screenshots/chat.png) | ![Verification](screenshots/verification.png) | ![Reset Password](screenshots/reset_password.png) |

---

## ✨ Features

- 🔐 **Email & Password Authentication** (Firebase Auth)
- ✅ **Email Verification** before accessing the chat
- 🔑 **Reset Password** via email link
- 💬 **Real-time Chat** with Firestore
- ⚡ **Loading indicators** with SpinKit animations
- 📱 **Responsive UI** with flutter_screenutil
- 🎨 **Custom reusable widgets** (Button, TextField, SnackBar)
- 🦸 **Hero animation** on the app name between screens
- 🗨️ **Chat bubbles** — sender (navy) / receiver (light gray)

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| Flutter | UI Framework |
| Firebase Auth | Authentication |
| Cloud Firestore | Real-time Database |
| flutter_spinkit | Loading animations |
| flutter_screenutil | Responsive sizing |
| email_validator | Email format validation |

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point & routes
├── constant.dart                # Colors & Firestore constants
├── firebase_options.dart        # Firebase config (auto-generated)
├── models/
│   └── message_model.dart       # Message data model
├── custom_widgets/
│   ├── chatBubble.dart          # Chat bubble widget
│   ├── custom_button.dart       # Reusable primary button
│   ├── custom_text_button.dart  # Reusable text button
│   ├── custom_text_filed.dart   # Reusable text field
│   └── show_snack_bar.dart      # Global snackbar helper
└── screens/
    ├── login.dart               # Login screen
    ├── register.dart            # Register screen
    ├── chat_screen.dart         # Main chat screen
    ├── verification_screen.dart # Email verification screen
    └── resetPassword.dart       # Reset password screen
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- A Firebase project

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/moalaa125/sawa.git
   cd sawa
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**
   - Create a project on [Firebase Console](https://console.firebase.google.com/)
   - Enable **Email/Password** Authentication
   - Enable **Cloud Firestore**
   - Run FlutterFire CLI:
     ```bash
     flutterfire configure
     ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

```yaml
dependencies:
  firebase_core: latest
  firebase_auth: latest
  cloud_firestore: latest
  flutter_spinkit: latest
  flutter_screenutil: latest
  email_validator: latest
```

---

## 🔒 Security Note

> ⚠️ Never commit your `firebase_options.dart` to a public repository.
> Add it to `.gitignore`:
> ```
> lib/firebase_options.dart
> ```

---

## 🐛 TODO

- [ ] Add message timestamps inside chat bubbles
- [ ] Add typing indicator
- [ ] Add user profile & avatar
- [ ] Add image sharing in chat
- [ ] Private chat rooms between users

---

## 👨‍💻 Author

**Mohamed Alaa**
- GitHub: [@moalaa125](https://github.com/moalaa125)

---

## 📄 License

This project is licensed under the MIT License.
