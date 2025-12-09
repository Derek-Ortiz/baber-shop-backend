# 📚 Guía Completa de API - BarberShop Backend

## 📋 Tabla de Contenidos

1. [Información General](#información-general)
2. [Endpoints de Autenticación](#endpoints-de-autenticación)
   - [Registro de Administrador](#1-registro-de-administrador)
   - [Login de Administrador](#2-login-de-administrador)
   - [Registro de Cliente](#3-registro-de-cliente)
   - [Login de Cliente](#4-login-de-cliente)
3. [Endpoints de Negocios (Barberías)](#endpoints-de-negocios-barberías)
4. [Endpoints de Horarios](#endpoints-de-horarios)
5. [Endpoints de Servicios](#endpoints-de-servicios)
6. [Endpoints de Citas](#endpoints-de-citas)
7. [Códigos de Estado HTTP](#códigos-de-estado-http)
8. [Troubleshooting](#troubleshooting)

---

## 🌐 Información General

### **Base URL**
```
http://localhost:9090/api
```

### **Headers Comunes**
Todas las peticiones POST, PUT y PATCH requieren:
```
Content-Type: application/json
```

### **Formato de Respuestas**

#### Éxito con datos:
```json
{
    "success": true,
    "message": "Mensaje descriptivo",
    "data": { ... }
}
```

#### Error:
```json
{
    "success": false,
    "message": "Descripción del error"
}
```

---

## 🔐 Endpoints de Autenticación

### 1. Registro de Administrador

**Endpoint:** `POST /api/auth/admin/register`

#### Parámetros (Body JSON):
| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `nombres` | String | ✅ | Nombre(s) del administrador |
| `apellidoP` | String | ✅ | Apellido paterno |
| `apellidoM` | String | ✅ | Apellido materno |
| `telefono` | String | ✅ | Número de teléfono |
| `email` | String | ✅ | Correo electrónico único |
| `contraseña` | String | ✅ | Contraseña (se hashea automáticamente) |
| `negocioId` | Int/null | ❌ | ID del negocio asignado (opcional) |

#### Ejemplo de Petición:
```json
{
    "nombres": "Carlos",
    "apellidoP": "Ramírez",
    "apellidoM": "González",
    "telefono": "5559876543",
    "email": "carlos.admin@barbershop.com",
    "contraseña": "adminPass123",
    "negocioId": null
}
```

#### Respuesta Exitosa (201 Created):
```json
{
    "success": true,
    "message": "Administrador registrado exitosamente",
    "data": {
        "id": 1,
        "nombres": "Carlos",
        "apellidoP": "Ramírez",
        "apellidoM": "González",
        "telefono": "5559876543",
        "email": "carlos.admin@barbershop.com",
        "negocioId": null
    }
}
```

#### Posibles Errores:
- **400 Bad Request:** Campos faltantes o formato incorrecto
- **500 Internal Server Error:** Email duplicado o error de base de datos

---

### 2. Login de Administrador

**Endpoint:** `POST /api/auth/admin/login`

#### Parámetros (Body JSON):
| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `email` | String | ✅ | Correo electrónico registrado |
| `contraseña` | String | ✅ | Contraseña del administrador |

#### Ejemplo de Petición:
```json
{
    "email": "carlos.admin@barbershop.com",
    "contraseña": "adminPass123"
}
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Login exitoso",
    "administrador": {
        "id": 1,
        "nombres": "Carlos",
        "apellidoP": "Ramírez",
        "apellidoM": "González",
        "telefono": "5559876543",
        "email": "carlos.admin@barbershop.com",
        "negocioId": null
    }
}
```

#### Posibles Errores:
- **401 Unauthorized:** Email o contraseña incorrectos
- **500 Internal Server Error:** Error del servidor

---

### 3. Registro de Cliente

**Endpoint:** `POST /api/auth/cliente/register`

#### Parámetros (Body JSON):
| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `nombres` | String | ✅ | Nombre(s) del cliente |
| `apellidoP` | String | ✅ | Apellido paterno |
| `apellidoM` | String | ✅ | Apellido materno |
| `telefono` | String | ✅ | Número de teléfono |
| `email` | String | ✅ | Correo electrónico único |
| `contraseña` | String | ✅ | Contraseña |
| `direccion` | String | ✅ | Dirección del cliente |

#### Ejemplo de Petición:
```json
{
    "nombres": "Juan",
    "apellidoP": "Pérez",
    "apellidoM": "García",
    "telefono": "5551234567",
    "email": "juan.perez@example.com",
    "contraseña": "miContraseña123",
    "direccion": "Calle Principal #123, Col. Centro"
}
```

#### Respuesta Exitosa (201 Created):
```json
{
    "success": true,
    "message": "Cliente registrado exitosamente",
    "data": {
        "id": 1,
        "nombres": "Juan",
        "apellidoP": "Pérez",
        "apellidoM": "García",
        "telefono": "5551234567",
        "email": "juan.perez@example.com",
        "direccion": "Calle Principal #123, Col. Centro"
    }
}
```

---

### 4. Login de Cliente

**Endpoint:** `POST /api/auth/cliente/login`

#### Parámetros (Body JSON):
| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `email` | String | ✅ | Correo electrónico registrado |
| `contraseña` | String | ✅ | Contraseña del cliente |

#### Ejemplo de Petición:
```json
{
    "email": "juan.perez@example.com",
    "contraseña": "miContraseña123"
}
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Login exitoso",
    "cliente": {
        "id": 1,
        "nombres": "Juan",
        "apellidoP": "Pérez",
        "apellidoM": "García",
        "telefono": "5551234567",
        "email": "juan.perez@example.com",
        "direccion": "Calle Principal #123, Col. Centro"
    }
}
```

---

## 🏢 Endpoints de Negocios (Barberías)

### 1. Listar Todas las Barberías

**Endpoint:** `GET /api/negocios`

#### Parámetros: Ninguno

#### Ejemplo de Petición:
```
GET http://localhost:9090/api/negocios
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Barberías obtenidas",
    "data": [
        {
            "id": 1,
            "nombreN": "Barbería Clásica",
            "direccion": "Av. Juárez #456"
        },
        {
            "id": 2,
            "nombreN": "BarberShop Premium",
            "direccion": "Calle Reforma #789"
        }
    ]
}
```

#### Posibles Errores:
- **500 Internal Server Error:** Error al consultar la base de datos

---

### 2. Obtener Barbería Completa (con Horarios y Servicios)

**Endpoint:** `GET /api/negocios/{id}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Descripción |
|-----------|-----------|------|-------------|
| `id` | Path | Int | ID de la barbería |

#### Ejemplo de Petición:
```
GET http://localhost:9090/api/negocios/1
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Barbería encontrada",
    "data": {
        "negocio": {
            "id": 1,
            "nombreN": "Barbería Clásica",
            "direccion": "Av. Juárez #456"
        },
        "horarios": [
            {
                "id": 1,
                "dia": "Lunes",
                "horaApertura": "09:00:00",
                "horaCierre": "18:00:00",
                "negocioId": 1
            },
            {
                "id": 2,
                "dia": "Martes",
                "horaApertura": "09:00:00",
                "horaCierre": "18:00:00",
                "negocioId": 1
            }
        ],
        "servicios": [
            {
                "id": 1,
                "nombre": "Corte de Cabello",
                "precio": 150.0,
                "duracion": 30,
                "negocioId": 1
            },
            {
                "id": 2,
                "nombre": "Barba",
                "precio": 100.0,
                "duracion": 20,
                "negocioId": 1
            }
        ]
    }
}
```

#### Posibles Errores:
- **400 Bad Request:** ID inválido (no numérico)
- **404 Not Found:** Barbería no encontrada
- **500 Internal Server Error:** Error del servidor

---

### 3. Crear Barbería

**Endpoint:** `POST /api/negocios`

#### Parámetros (Body JSON):
| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `nombreN` | String | ✅ | Nombre de la barbería |
| `direccion` | String | ✅ | Dirección de la barbería |

#### Ejemplo de Petición:
```json
{
    "nombreN": "Barbería Moderna",
    "direccion": "Blvd. Insurgentes #321, Col. Roma"
}
```

#### Respuesta Exitosa (201 Created):
```json
{
    "success": true,
    "message": "Barbería creada",
    "data": {
        "id": 3,
        "nombreN": "Barbería Moderna",
        "direccion": "Blvd. Insurgentes #321, Col. Roma"
    }
}
```

#### Posibles Errores:
- **400 Bad Request:** Campos faltantes o inválidos
- **500 Internal Server Error:** Error al crear en la base de datos

---

### 4. Actualizar Barbería

**Endpoint:** `PUT /api/negocios/{id}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Obligatorio | Descripción |
|-----------|-----------|------|-------------|-------------|
| `id` | Path | Int | ✅ | ID de la barbería |
| `nombreN` | Body JSON | String | ✅ | Nuevo nombre |
| `direccion` | Body JSON | String | ✅ | Nueva dirección |

#### Ejemplo de Petición:
```
PUT http://localhost:9090/api/negocios/1
```

Body:
```json
{
    "nombreN": "Barbería Clásica Renovada",
    "direccion": "Av. Juárez #456-A"
}
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Actualizada",
    "data": null
}
```

#### Posibles Errores:
- **400 Bad Request:** ID inválido
- **404 Not Found:** Barbería no encontrada
- **500 Internal Server Error:** Error del servidor

---

### 5. Eliminar Barbería

**Endpoint:** `DELETE /api/negocios/{id}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Descripción |
|-----------|-----------|------|-------------|
| `id` | Path | Int | ID de la barbería a eliminar |

#### Ejemplo de Petición:
```
DELETE http://localhost:9090/api/negocios/3
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Eliminada",
    "data": null
}
```

#### Posibles Errores:
- **400 Bad Request:** ID inválido
- **404 Not Found:** Barbería no encontrada
- **500 Internal Server Error:** Error al eliminar (puede tener registros relacionados)

---

## 🕒 Endpoints de Horarios

### 1. Agregar Horario a una Barbería

**Endpoint:** `POST /api/horarios`

#### Parámetros (Body JSON):
| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `dia` | String | ✅ | Día de la semana |
| `horaApertura` | String | ✅ | Hora de apertura (formato HH:mm:ss) |
| `horaCierre` | String | ✅ | Hora de cierre (formato HH:mm:ss) |
| `negocioId` | Int | ✅ | ID de la barbería |

#### Ejemplo de Petición:
```json
{
    "dia": "Miércoles",
    "horaApertura": "09:00:00",
    "horaCierre": "18:00:00",
    "negocioId": 1
}
```

#### Respuesta Exitosa (201 Created):
```json
{
    "success": true,
    "message": "Horario agregado",
    "data": {
        "id": 3,
        "dia": "Miércoles",
        "horaApertura": "09:00:00",
        "horaCierre": "18:00:00",
        "negocioId": 1
    }
}
```

#### Posibles Errores:
- **400 Bad Request:** Campos faltantes, formato de hora incorrecto, o negocioId no existe
- **500 Internal Server Error:** Error al guardar en la base de datos

#### Notas Importantes:
- Los días válidos son: "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"
- El formato de hora debe ser `HH:mm:ss` (24 horas)
- Ejemplos válidos: "09:00:00", "18:30:00", "23:59:59"

---

### 2. Actualizar Horario

**Endpoint:** `PUT /api/horarios/{id}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Obligatorio | Descripción |
|-----------|-----------|------|-------------|-------------|
| `id` | Path | Int | ✅ | ID del horario |
| `dia` | Body JSON | String | ✅ | Nuevo día |
| `horaApertura` | Body JSON | String | ✅ | Nueva hora apertura |
| `horaCierre` | Body JSON | String | ✅ | Nueva hora cierre |
| `negocioId` | Body JSON | Int | ✅ | ID del negocio |

#### Ejemplo de Petición:
```
PUT http://localhost:9090/api/horarios/1
```

Body:
```json
{
    "dia": "Lunes",
    "horaApertura": "08:00:00",
    "horaCierre": "20:00:00",
    "negocioId": 1
}
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Actualizado",
    "data": null
}
```

#### Posibles Errores:
- **400 Bad Request:** ID inválido o datos incorrectos
- **404 Not Found:** Horario no encontrado

---

### 3. Eliminar Horario

**Endpoint:** `DELETE /api/horarios/{id}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Descripción |
|-----------|-----------|------|-------------|
| `id` | Path | Int | ID del horario a eliminar |

#### Ejemplo de Petición:
```
DELETE http://localhost:9090/api/horarios/3
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Eliminado",
    "data": null
}
```

#### Posibles Errores:
- **400 Bad Request:** ID inválido
- **404 Not Found:** Horario no encontrado

---

## 💇 Endpoints de Servicios

### 1. Agregar Servicio a una Barbería

**Endpoint:** `POST /api/servicios`

#### Parámetros (Body JSON):
| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `nombre` | String | ✅ | Nombre del servicio |
| `precio` | Float | ✅ | Precio del servicio |
| `duracion` | Int | ✅ | Duración en minutos |
| `negocioId` | Int | ✅ | ID de la barbería |

#### Ejemplo de Petición:
```json
{
    "nombre": "Corte + Barba Completo",
    "precio": 250.0,
    "duracion": 50,
    "negocioId": 1
}
```

#### Respuesta Exitosa (201 Created):
```json
{
    "success": true,
    "message": "Servicio agregado",
    "data": {
        "id": 3,
        "nombre": "Corte + Barba Completo",
        "precio": 250.0,
        "duracion": 50,
        "negocioId": 1
    }
}
```

#### Posibles Errores:
- **400 Bad Request:** Campos faltantes, precio negativo, duración <= 0, o negocioId no existe
- **500 Internal Server Error:** Error al guardar

#### Notas Importantes:
- El precio debe ser un número positivo (puede tener decimales)
- La duración debe ser en minutos (número entero positivo)
- Ejemplos de servicios: "Corte de Cabello", "Barba", "Tinte", "Delineado"

---

### 2. Actualizar Servicio

**Endpoint:** `PUT /api/servicios/{id}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Obligatorio | Descripción |
|-----------|-----------|------|-------------|-------------|
| `id` | Path | Int | ✅ | ID del servicio |
| `nombre` | Body JSON | String | ✅ | Nuevo nombre |
| `precio` | Body JSON | Float | ✅ | Nuevo precio |
| `duracion` | Body JSON | Int | ✅ | Nueva duración |
| `negocioId` | Body JSON | Int | ✅ | ID del negocio |

#### Ejemplo de Petición:
```
PUT http://localhost:9090/api/servicios/1
```

Body:
```json
{
    "nombre": "Corte de Cabello Premium",
    "precio": 180.0,
    "duracion": 40,
    "negocioId": 1
}
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Actualizado",
    "data": null
}
```

#### Posibles Errores:
- **400 Bad Request:** ID inválido o datos incorrectos
- **404 Not Found:** Servicio no encontrado

---

### 3. Eliminar Servicio

**Endpoint:** `DELETE /api/servicios/{id}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Descripción |
|-----------|-----------|------|-------------|
| `id` | Path | Int | ID del servicio a eliminar |

#### Ejemplo de Petición:
```
DELETE http://localhost:9090/api/servicios/3
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Eliminado",
    "data": null
}
```

#### Posibles Errores:
- **400 Bad Request:** ID inválido
- **404 Not Found:** Servicio no encontrado
- **500 Internal Server Error:** No se puede eliminar (puede tener citas asociadas)

---

## 📅 Endpoints de Citas

### 1. Obtener Historial de Citas del Cliente

**Endpoint:** `GET /api/citas/cliente/{clienteId}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Descripción |
|-----------|-----------|------|-------------|
| `clienteId` | Path | Int | ID del cliente |

#### Ejemplo de Petición:
```
GET http://localhost:9090/api/citas/cliente/1
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Historial de citas",
    "data": [
        {
            "cita": {
                "id": 1,
                "fechaRealizacion": "2025-12-05",
                "fechaCita": "2025-12-05",
                "precio": 150.0,
                "asunto": "Corte de cabello",
                "estado": "Completada",
                "clienteId": 1,
                "negocioId": 1,
                "servicioId": 1
            },
            "cliente": {
                "id": 1,
                "nombres": "Juan",
                "apellidoP": "Pérez",
                "apellidoM": "García",
                "telefono": "5551234567",
                "email": "juan.perez@example.com",
                "direccion": "Calle Principal #123"
            },
            "negocio": {
                "id": 1,
                "nombreN": "Barbería Clásica",
                "direccion": "Av. Juárez #456"
            },
            "servicio": {
                "id": 1,
                "nombre": "Corte de Cabello",
                "precio": 150.0,
                "duracion": 30,
                "negocioId": 1
            }
        }
    ]
}
```

#### Posibles Errores:
- **400 Bad Request:** ID de cliente inválido
- **500 Internal Server Error:** Error del servidor

---

### 2. Obtener Citas Pendientes del Cliente

**Endpoint:** `GET /api/citas/cliente/{clienteId}/pendientes`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Descripción |
|-----------|-----------|------|-------------|
| `clienteId` | Path | Int | ID del cliente |

#### Ejemplo de Petición:
```
GET http://localhost:9090/api/citas/cliente/1/pendientes
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Citas pendientes",
    "data": [
        {
            "cita": {
                "id": 2,
                "fechaRealizacion": null,
                "fechaCita": "2025-12-15",
                "precio": 250.0,
                "asunto": "Corte + Barba",
                "estado": "Pendiente",
                "clienteId": 1,
                "negocioId": 1,
                "servicioId": 3
            },
            "cliente": { ... },
            "negocio": { ... },
            "servicio": { ... }
        }
    ]
}
```

#### Estados de Citas:
- **"Pendiente"**: Cita programada, aún no realizada
- **"Completada"**: Cita realizada
- **"Cancelada"**: Cita cancelada

---

### 3. Obtener Historial de Clientes de una Barbería

**Endpoint:** `GET /api/citas/negocio/{negocioId}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Descripción |
|-----------|-----------|------|-------------|
| `negocioId` | Path | Int | ID de la barbería |

#### Ejemplo de Petición:
```
GET http://localhost:9090/api/citas/negocio/1
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Historial de clientes",
    "data": [
        {
            "cita": { ... },
            "cliente": { ... },
            "negocio": { ... },
            "servicio": { ... }
        }
    ]
}
```

#### Uso:
- El administrador de la barbería puede ver todas las citas (pasadas y futuras)
- Útil para reportes y estadísticas

---

### 4. Reservar Cita

**Endpoint:** `POST /api/citas`

#### Parámetros (Body JSON):
| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `fechaCita` | String | ✅ | Fecha de la cita (formato YYYY-MM-DD) |
| `asunto` | String | ✅ | Descripción/motivo de la cita |
| `clienteId` | Int | ✅ | ID del cliente |
| `negocioId` | Int | ✅ | ID de la barbería |
| `servicioId` | Int | ✅ | ID del servicio |

#### Ejemplo de Petición:
```json
{
    "fechaCita": "2025-12-20",
    "asunto": "Corte de cabello y arreglo de barba",
    "clienteId": 1,
    "negocioId": 1,
    "servicioId": 3
}
```

#### Respuesta Exitosa (201 Created):
```json
{
    "success": true,
    "message": "Cita reservada exitosamente",
    "data": {
        "id": 3,
        "fechaRealizacion": null,
        "fechaCita": "2025-12-20",
        "precio": 250.0,
        "asunto": "Corte de cabello y arreglo de barba",
        "estado": "Pendiente",
        "clienteId": 1,
        "negocioId": 1,
        "servicioId": 3
    }
}
```

#### Posibles Errores:
- **400 Bad Request:** 
  - Campos faltantes
  - Formato de fecha incorrecto
  - ClienteId, negocioId o servicioId no existen
  - Fecha en el pasado
- **500 Internal Server Error:** Error al guardar

#### Notas Importantes:
- El formato de fecha debe ser `YYYY-MM-DD` (ejemplo: "2025-12-20")
- El precio se calcula automáticamente desde el servicio
- El estado inicial es siempre "Pendiente"
- `fechaRealizacion` es null hasta que se complete la cita

---

### 5. Actualizar Estado de Cita

**Endpoint:** `PATCH /api/citas/{id}/estado`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Obligatorio | Descripción |
|-----------|-----------|------|-------------|-------------|
| `id` | Path | Int | ✅ | ID de la cita |
| `estado` | Body JSON | String | ✅ | Nuevo estado |

#### Estados Válidos:
- `"Pendiente"`
- `"Completada"`
- `"Cancelada"`

#### Ejemplo de Petición:
```
PATCH http://localhost:9090/api/citas/2/estado
```

Body:
```json
{
    "estado": "Completada"
}
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Estado actualizado",
    "data": null
}
```

#### Posibles Errores:
- **400 Bad Request:** ID inválido o estado no válido
- **404 Not Found:** Cita no encontrada

#### Notas:
- Cuando cambias a "Completada", se actualiza automáticamente `fechaRealizacion` con la fecha actual
- Útil para que los administradores marquen las citas como completadas

---

### 6. Cancelar Cita

**Endpoint:** `DELETE /api/citas/{id}`

#### Parámetros:
| Parámetro | Ubicación | Tipo | Descripción |
|-----------|-----------|------|-------------|
| `id` | Path | Int | ID de la cita a cancelar |

#### Ejemplo de Petición:
```
DELETE http://localhost:9090/api/citas/3
```

#### Respuesta Exitosa (200 OK):
```json
{
    "success": true,
    "message": "Cita cancelada",
    "data": null
}
```

#### Posibles Errores:
- **400 Bad Request:** ID inválido
- **404 Not Found:** Cita no encontrada

#### Notas:
- Esta acción marca la cita como "Cancelada" (no la elimina de la base de datos)
- Tanto clientes como administradores pueden cancelar citas

---

## 📊 Códigos de Estado HTTP

| Código | Significado | Cuándo se usa |
|--------|-------------|---------------|
| **200 OK** | Éxito | GET, PUT, PATCH, DELETE exitosos |
| **201 Created** | Recurso creado | POST exitoso |
| **400 Bad Request** | Solicitud inválida | Datos faltantes o incorrectos |
| **401 Unauthorized** | No autorizado | Login fallido |
| **404 Not Found** | No encontrado | Recurso no existe o ruta incorrecta |
| **500 Internal Server Error** | Error del servidor | Error en base de datos o del servidor |

---

## 🔧 Troubleshooting

### Error 404: Recurso no encontrado

**Problema:** La URL está incorrecta

**Solución:**
- Verifica que la URL incluya `/api` al inicio
- Correcta: `http://localhost:9090/api/auth/cliente/register`
- Incorrecta: `http://localhost:9090/auth/cliente/register`

### Error 400 sin feedback

**Problema:** El Content-Type no está configurado

**Solución:**
- Agrega el header: `Content-Type: application/json`
- Verifica que el JSON esté bien formado (sin comas extras, comillas correctas)

### Error 500: Error interno del servidor

**Posibles causas:**
1. **Email duplicado:** Intenta registrar con un email que ya existe
2. **ID no existe:** Estás referenciando un negocioId, servicioId, etc. que no existe
3. **Base de datos no disponible:** El servidor no puede conectarse a la BD

**Solución:**
- Revisa los logs del servidor en la consola
- Cambia el email o usa datos diferentes
- Verifica que el servidor esté corriendo correctamente

### Connection Refused

**Problema:** El servidor no está corriendo

**Solución:**
```powershell
cd "C:\Users\Derek\Desktop\Proyecto-moviles\Backend-project-1.0\backend-BarberShop"
.\gradlew.bat run
```

Espera a ver:
```
[main] INFO Application - Responding at http://0.0.0.0:9090
```

### Formato de fecha/hora incorrecto

**Problema:** Error al enviar fechas u horas

**Soluciones:**
- **Fechas:** Usa formato `YYYY-MM-DD` (ejemplo: "2025-12-20")
- **Horas:** Usa formato `HH:mm:ss` (ejemplo: "09:00:00", "18:30:00")

---

## 🧪 Health Check

Para verificar que el servidor está funcionando:

**Endpoint:** `GET /api/health`

**Ejemplo:**
```
GET http://localhost:9090/api/health
```

**Respuesta:**
```json
{
    "status": "OK",
    "message": "Barbershop API funcionando correctamente",
    "version": "1.0.0"
}
```

---

## 📝 Flujo de Uso Típico

### Para Clientes:

1. **Registrarse:** `POST /api/auth/cliente/register`
2. **Login:** `POST /api/auth/cliente/login`
3. **Ver barberías disponibles:** `GET /api/negocios`
4. **Ver detalles de una barbería:** `GET /api/negocios/{id}`
5. **Reservar una cita:** `POST /api/citas`
6. **Ver mis citas pendientes:** `GET /api/citas/cliente/{clienteId}/pendientes`
7. **Cancelar una cita:** `DELETE /api/citas/{id}`

### Para Administradores:

1. **Registrarse:** `POST /api/auth/admin/register`
2. **Login:** `POST /api/auth/admin/login`
3. **Crear barbería:** `POST /api/negocios`
4. **Agregar horarios:** `POST /api/horarios`
5. **Agregar servicios:** `POST /api/servicios`
6. **Ver citas del negocio:** `GET /api/citas/negocio/{negocioId}`
7. **Actualizar estado de cita:** `PATCH /api/citas/{id}/estado`

---

## 📚 Resumen de Endpoints

### Autenticación
- `POST /api/auth/admin/register` - Registrar administrador
- `POST /api/auth/admin/login` - Login administrador
- `POST /api/auth/cliente/register` - Registrar cliente
- `POST /api/auth/cliente/login` - Login cliente

### Negocios
- `GET /api/negocios` - Listar todas
- `GET /api/negocios/{id}` - Obtener con detalles
- `POST /api/negocios` - Crear
- `PUT /api/negocios/{id}` - Actualizar
- `DELETE /api/negocios/{id}` - Eliminar

### Horarios
- `POST /api/horarios` - Agregar
- `PUT /api/horarios/{id}` - Actualizar
- `DELETE /api/horarios/{id}` - Eliminar

### Servicios
- `POST /api/servicios` - Agregar
- `PUT /api/servicios/{id}` - Actualizar
- `DELETE /api/servicios/{id}` - Eliminar

### Citas
- `GET /api/citas/cliente/{clienteId}` - Historial del cliente
- `GET /api/citas/cliente/{clienteId}/pendientes` - Pendientes del cliente
- `GET /api/citas/negocio/{negocioId}` - Historial del negocio
- `POST /api/citas` - Reservar
- `PATCH /api/citas/{id}/estado` - Actualizar estado
- `DELETE /api/citas/{id}` - Cancelar

---

**Versión:** 1.0.0  
**Última actualización:** 2025-12-09  
**Puerto del servidor:** 9090  
**Base URL:** http://localhost:9090/api

