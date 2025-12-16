# 📍 GeoNotes – GPS + Notes Mobile App

Aplicación móvil desarrollada en **Flutter** que permite al usuario crear notas asociadas a una ubicación GPS específica. El proyecto fue desarrollado como caso de estudio académico aplicando **Metodología Ágil SCRUM**, **Clean Architecture** y el patrón de diseño **MVP**, dejando la base preparada para futuras integraciones con **APIs externas, servicios en la nube y mecanismos de seguridad**.

---

## 📌 Descripción del Proyecto

GeoNotes es una aplicación móvil que permite:

* Registrar notas manuales.
* Asociar cada nota con coordenadas GPS (latitud y longitud).
* Almacenar la información de forma local.
* Visualizar notas vinculadas a ubicaciones específicas.

La aplicación está diseñada para escalar a futuro, permitiendo:

* Integración con APIs externas (Google Maps, OpenStreetMap).
* Sincronización en la nube.
* Autenticación de usuarios.

---

## 🧠 Metodología Ágil

El desarrollo del proyecto sigue la metodología **SCRUM**, con:

* Backlog de producto definido mediante historias de usuario.
* Sprints planificados (conceptualmente de 2 semanas).
* Seguimiento mediante tablero Scrum.
* Uso de control de versiones para trazabilidad.

---

## 🏗 Arquitectura de Software

Se implementa **Clean Architecture**, separando responsabilidades en capas bien definidas:

* **Presentation**: UI y lógica de presentación (MVP).
* **Domain**: Entidades y casos de uso.
* **Data**: Repositorios y fuentes de datos.
* **Infrastructure**: Acceso a GPS, almacenamiento local y futuras APIs.

Esta arquitectura facilita:

* Escalabilidad.
* Mantenibilidad.
* Pruebas unitarias.
* Independencia tecnológica.

---

## 🎯 Patrones de Diseño Utilizados

### MVP (Model – View – Presenter)

* **View**: Widgets Flutter.
* **Presenter**: Lógica de presentación.
* **Model**: Entidades del dominio.

### Repository Pattern

* Abstracción del acceso a datos.
* Permite intercambiar fuentes locales o remotas sin afectar la lógica de negocio.

### Dependency Injection

* Uso de **GetIt** como contenedor de dependencias.
* Facilita pruebas unitarias y desacoplamiento.

---

## 📱 Uso de Periféricos del Móvil

* 📍 **GPS**: Obtención de ubicación actual.
* 💾 **Almacenamiento local**: Guardado de notas.

---

## 🧪 Esquema de Pruebas

* **Pruebas unitarias**: lógica de dominio y presenters.
* **Pruebas de integración**: repositorios.
* Preparado para pruebas automáticas futuras.

Herramientas:

* `flutter_test`

---

## 🔐 Seguridad (Preparado)

* Arquitectura preparada para autenticación.
* Manejo seguro de permisos (GPS).
* Posible integración con OAuth / JWT a futuro.

---

## ☁️ Servicios en la Nube (A Futuro)

* Este proyecto utiliza Firebase como base de datos.

---

## 🔄 Estrategia de Versionamiento

Se utiliza **Git Flow**:

* `main`: versión estable.
* `develop`: desarrollo activo.
* `feature/*`: nuevas funcionalidades.

---

## 🧰 Herramientas Utilizadas

* **Framework**: Flutter
* **Lenguaje**: Dart
* **IDE**: Visual Studio Code
* **Control de Versiones**: Git
* **Repositorio**: GitHub

---

## ⚙️ Parámetros de Configuración

* SO: Windows 10
* Flutter SDK: versión estable
* Dart SDK: compatible con Flutter
* Emulador: Android Emulator (API 34+)

---

## 📁 Estructura del Proyecto

```text
lib/
├── core/
│   ├── errors/
│   ├── usecases/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── pages/
│   ├── presenters/
│   └── widgets/
├── injection_container.dart
└── main.dart
```

---

## 👤 Autor

Joel Rodrigo Salcedo Cheno

---

## 📌 Estado del Proyecto

🚧 En desarrollo – Base arquitectónica implementada.

---

## 📄 Licencia

Proyecto académico sin fines comerciales.
