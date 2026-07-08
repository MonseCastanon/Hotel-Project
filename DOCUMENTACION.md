# Plan de Ejecución Profesional
# Proyecto Hotel - Aplicación Multidispositivo Flutter (Mobile + Wear OS)

## Objetivo

Desarrollar una solución multidispositivo completamente en Flutter para la gestión operativa de un hotel, permitiendo la sincronización en tiempo real entre la aplicación móvil y la aplicación Wear OS.

El sistema permitirá administrar habitaciones, reservas y tareas operativas, manteniendo una arquitectura escalable, código reutilizable y buenas prácticas de desarrollo.

---

# Arquitectura General

```text
                   Backend
                       │
               REST API / WebSocket
                       │
        ┌──────────────┴──────────────┐
        │                             │
 Flutter Mobile                 Flutter Wear
        │                             │
        └──────── Comunicación ───────┘
```

Todo el desarrollo será realizado en Flutter.

---

# Tecnologías

## Framework

- Flutter 3.x
- Dart

## Gestión de estado

- Riverpod

## Arquitectura

- Clean Architecture

Organizada en:

- config
- domain
- infrastructure
- presentation

## Navegación

- GoRouter

## Networking

- Dio

## Tiempo real

- WebSocket

## Persistencia

- Hive
- SharedPreferences

## Responsive

- flutter_screenutil

## UI

- Material Design 3

## Utilidades

- flutter_svg
- google_fonts
- intl
- logger
- connectivity_plus

---

# Estructura del Proyecto

```text
lib/
│
├── config
│   ├── constants
│   ├── helpers
│   ├── routers
│   ├── services
│   └── theme
│
├── domain
│   ├── datasource
│   ├── entities
│   ├── repositories
│   └── usecases (opcional)
│
├── infrastructure
│   ├── datasource
│   ├── mappers
│   ├── models
│   │   ├── auth
│   │   ├── room
│   │   ├── reservation
│   │   ├── notification
│   │   └── wear
│   └── repositories
│
└── presentation
    ├── providers
    │   ├── auth
    │   ├── dashboard
    │   ├── rooms
    │   ├── reservations
    │   ├── notifications
    │   └── wear
    │
    ├── screens
    │   ├── auth
    │   ├── dashboard
    │   ├── rooms
    │   ├── reservations
    │   ├── notifications
    │   ├── profile
    │   └── wear
    │
    ├── widgets
    │   ├── shared
    │   ├── rooms
    │   ├── reservations
    │   ├── dashboard
    │   └── wear
    │
    └── views
```

---

# Pantallas Mobile

- Splash
- Login
- Dashboard
- Habitaciones
- Detalle de habitación
- Check-in
- Check-out
- Reservaciones
- Notificaciones
- Perfil

---

# Pantallas Wear

- Dashboard
- Alertas
- Historial
- Confirmación
- Resumen

---

# Entidades

- User
- Room
- Reservation
- Task
- Notification
- WearTask

---

# Repositorios

- AuthenticationRepository
- RoomRepository
- ReservationRepository
- NotificationRepository
- WearRepository

---

# Servicios

- ApiService
- StorageService
- NotificationService
- SocketService
- WearCommunicationService

---

# Flujo del Sistema

Recepcionista realiza un Check-out

↓

Backend actualiza la habitación

↓

La aplicación móvil recibe la actualización

↓

Se genera una nueva tarea para limpieza

↓

La aplicación Wear recibe la notificación

↓

El empleado acepta la tarea

↓

La aplicación Wear envía la respuesta

↓

La aplicación móvil sincroniza el nuevo estado

↓

Todos los dispositivos actualizan la información en tiempo real.

---

# Comunicación entre dispositivos

La comunicación entre la aplicación móvil y Wear estará centralizada mediante:

- WearCommunicationService

Responsabilidades:

- sendTask()
- acceptTask()
- startTask()
- finishTask()
- receiveUpdates()

---

# Gestión de Estado

Toda la aplicación utilizará Riverpod.

No se utilizará `setState()` para lógica de negocio.

---

# Diseño

Se utilizará Material Design 3.

Toda la aplicación compartirá:

- Paleta de colores
- Tipografía
- Iconografía
- Componentes reutilizables
- Espaciados

---

# Buenas prácticas

- Clean Architecture
- SOLID
- Repository Pattern
- Null Safety
- Conventional Commits
- Linter oficial de Flutter

---

# Resultado Esperado

El proyecto deberá entregar:

- Aplicación Flutter Mobile completamente funcional.
- Aplicación Flutter Wear integrada.
- Comunicación entre dispositivos.
- Arquitectura escalable.
- Código limpio y reutilizable.
- Proyecto preparado para futuras ampliaciones.