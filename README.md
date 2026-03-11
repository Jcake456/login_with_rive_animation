# 🐻 Animated Bear Login

Welcome to **Animated Bear Login** — a modern Flutter login interface enhanced with interactive Rive animations and state machine logic for a smooth and engaging user experience.

---

## 👤 Project Information

- **Name:** Juan Carlos Castelan Ake  
- **Teacher:** Rodrigo Fidel Gaxiola Sosa  
- **Subject:** Graficación  

---

## 📌 Description

🚀 This project showcases a modern login screen built with **Flutter**, integrated with **Rive** animations powered by a **State Machine**.  

The animated bear reacts dynamically to user interactions, creating a playful yet functional authentication experience.

The goal of this project is to demonstrate how real-time animations can improve user experience through interaction-driven design.

---

## 🌟 Features

- 🔒 Password visibility toggle  
- 👀 Animated reactions to user actions (typing, checking, success, error)  
- 🎯 Interactive State Machine logic  
- 💡 Clean UI built with Flutter’s Material components  
- ⏳ Responsive behavior using timers and animation triggers  

---

## 🎨 What is Rive?

Rive is a real-time interactive animation tool and runtime that allows developers and designers to create lightweight, high-performance vector animations for web, mobile, and game applications.  

Unlike traditional animations (such as GIFs or pre-rendered videos), Rive animations are **dynamic and state-driven**. This means they can respond to user interactions, application logic, and real-time data.  

Because animations are rendered programmatically, they are optimized for performance and ideal for modern, interactive user interfaces.

### Common Use Cases:
- ✨ Interactive UI elements  
- 🎮 Game animations  
- 📱 Mobile app micro-interactions  
- 🌐 Web-based animations  

---

## 🔄 What is a State Machine in Rive?

A **State Machine** in Rive controls how and when animations transition between different states. Instead of playing a single linear animation, it allows you to define multiple states such as:

- `idle`
- `hover`
- `pressed`
- `success`
- `error`

Transitions between these states are triggered using:

- ✅ Boolean inputs  
- 🔢 Numeric inputs  
- 🚀 Trigger inputs  

This enables animations to react automatically to user interactions or application events.

For example, in this project:
- The bear looks at the text field while typing 👀  
- Covers its eyes when entering a password 🙈  
- Reacts differently on success or error ✅❌  

In short, **State Machines make Rive animations interactive, responsive, and deeply integrated with application logic.**

🛠️ __Technologies Used__

🧩 Flutter — UI framework

🎬 Rive — animation integration

🧠 StateMachineController — for handling animation logic

💻 Dart — programming language

---

## 📂 Project Structure

Below is the folder structure of the project:

```bash
login_with_animation_5sa/
├── assets/
│   └── rive/                 # Rive animation file (.riv)
├── lib/
│   ├── main.dart             # Application entry point
│   └── screens/
│       └── login_screen.dart # Login screen with bear animation
└── pubspec.yaml              # Dependencies and assets configuration
```

This structure keeps the project organized by separating:
- 🎨 Animation assets  
- 🧠 Application logic  
- 🖥️ UI screens  
- 📦 Dependency configuration

## 🎥 Demo

## 🎥 Demo

<p align="center">
  <img src="assets/Grabación 2026-03-10 221719" width="800" alt="Animated Bear Login Demo">
</p>


---

## ⚙️ Animation Creator

Rive animation used in this project: [Remix of Login Machine](https://rive.app/marketplace/3645-7621-remix-of-login-machine/)
