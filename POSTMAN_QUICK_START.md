# 🚀 Guía Rápida - Importar Colección en Postman

## 📥 Cómo Importar la Colección

### Opción 1: Importar desde archivo

1. **Abre Postman**
2. Click en el botón **"Import"** (esquina superior izquierda)
3. Arrastra el archivo `BarberShop_Postman_Collection.json` o click en **"Upload Files"**
4. Selecciona el archivo y click en **"Import"**
5. ¡Listo! La colección aparecerá en tu sidebar izquierdo

### Opción 2: Importar manualmente

Si tienes problemas con el archivo JSON:

1. Abre Postman
2. Crea una nueva colección llamada "BarberShop API"
3. Crea carpetas para cada sección (Autenticación, Negocios, etc.)
4. Copia las peticiones del archivo `POSTMAN_API_GUIDE.md`

---

## 🎯 Prueba Rápida - Orden Recomendado

### 1️⃣ Verifica que el servidor esté corriendo

**Petición:** Health Check
- **Método:** GET
- **URL:** `http://localhost:9090/api/health`
- **Resultado esperado:** Status 200, mensaje "OK"

Si esto falla, inicia el servidor:
```powershell
cd "C:\Users\Derek\Desktop\Proyecto-moviles\Backend-project-1.0\backend-BarberShop"
.\gradlew.bat run
```

---

### 2️⃣ Registra un Administrador

**Petición:** Autenticación → Registro Admin

**Body:**
```json
{
    "nombres": "Admin",
    "apellidoP": "Principal",
    "apellidoM": "Sistema",
    "telefono": "5551111111",
    "email": "admin@barbershop.com",
    "contraseña": "admin123",
    "negocioId": null
}
```

**Resultado esperado:** Status 201, admin creado con ID 1

---

### 3️⃣ Crea una Barbería

**Petición:** Negocios → Crear Barbería

**Body:**
```json
{
    "nombreN": "Mi Primera Barbería",
    "direccion": "Calle Principal #100"
}
```

**Resultado esperado:** Status 201, barbería creada con ID 1

---

### 4️⃣ Agrega Horarios

**Petición:** Horarios → Agregar Horario

Agrega varios días de la semana:

**Lunes:**
```json
{
    "dia": "Lunes",
    "horaApertura": "09:00:00",
    "horaCierre": "18:00:00",
    "negocioId": 1
}
```

**Martes:**
```json
{
    "dia": "Martes",
    "horaApertura": "09:00:00",
    "horaCierre": "18:00:00",
    "negocioId": 1
}
```

Repite para los demás días...

---

### 5️⃣ Agrega Servicios

**Petición:** Servicios → Agregar Servicio

**Servicio 1 - Corte:**
```json
{
    "nombre": "Corte de Cabello",
    "precio": 150.0,
    "duracion": 30,
    "negocioId": 1
}
```

**Servicio 2 - Barba:**
```json
{
    "nombre": "Arreglo de Barba",
    "precio": 100.0,
    "duracion": 20,
    "negocioId": 1
}
```

**Servicio 3 - Combo:**
```json
{
    "nombre": "Corte + Barba",
    "precio": 220.0,
    "duracion": 45,
    "negocioId": 1
}
```

---

### 6️⃣ Verifica la Barbería Completa

**Petición:** Negocios → Obtener Barbería Completa

**URL:** `http://localhost:9090/api/negocios/1`

**Resultado esperado:** Barbería con sus horarios y servicios

---

### 7️⃣ Registra un Cliente

**Petición:** Autenticación → Registro Cliente

**Body:**
```json
{
    "nombres": "Juan",
    "apellidoP": "Pérez",
    "apellidoM": "García",
    "telefono": "5552222222",
    "email": "juan@example.com",
    "contraseña": "cliente123",
    "direccion": "Calle Secundaria #200"
}
```

**Resultado esperado:** Status 201, cliente creado con ID 1

---

### 8️⃣ Reserva una Cita

**Petición:** Citas → Reservar Cita

**Body:**
```json
{
    "fechaCita": "2025-12-15",
    "asunto": "Corte de cabello regular",
    "clienteId": 1,
    "negocioId": 1,
    "servicioId": 1
}
```

**Resultado esperado:** Status 201, cita creada con estado "Pendiente"

---

### 9️⃣ Consulta las Citas

**Ver citas del cliente:**
- **URL:** `http://localhost:9090/api/citas/cliente/1/pendientes`

**Ver citas del negocio:**
- **URL:** `http://localhost:9090/api/citas/negocio/1`

---

### 🔟 Actualiza el Estado de la Cita

**Petición:** Citas → Actualizar Estado Cita

**URL:** `http://localhost:9090/api/citas/1/estado`

**Body:**
```json
{
    "estado": "Completada"
}
```

---

## 📊 Variables de Entorno (Opcional)

Para facilitar las pruebas, puedes crear variables de entorno en Postman:

### Crear Environment:

1. Click en el ícono de engranaje (Environments)
2. Click en "Add"
3. Nombre: "BarberShop Local"
4. Agrega estas variables:

| Variable | Initial Value | Current Value |
|----------|---------------|---------------|
| `base_url` | `http://localhost:9090/api` | `http://localhost:9090/api` |
| `admin_id` | `1` | `1` |
| `cliente_id` | `1` | `1` |
| `negocio_id` | `1` | `1` |
| `servicio_id` | `1` | `1` |
| `cita_id` | `1` | `1` |

### Usar Variables:

Cambia las URLs de:
```
http://localhost:9090/api/negocios/1
```

A:
```
{{base_url}}/negocios/{{negocio_id}}
```

---

## 🧪 Casos de Prueba Completos

### Escenario 1: Flujo Completo de Cliente

```
1. Health Check ✓
2. Registro Cliente ✓
3. Login Cliente ✓
4. Listar Barberías ✓
5. Ver Barbería Específica ✓
6. Reservar Cita ✓
7. Ver Citas Pendientes ✓
8. Cancelar Cita ✓
```

### Escenario 2: Flujo Completo de Administrador

```
1. Health Check ✓
2. Registro Admin ✓
3. Login Admin ✓
4. Crear Barbería ✓
5. Agregar Horarios (7 días) ✓
6. Agregar Servicios (3 servicios) ✓
7. Ver Barbería Completa ✓
8. Ver Citas del Negocio ✓
9. Actualizar Estado de Citas ✓
```

### Escenario 3: Pruebas de Error

```
1. Registro con email duplicado (400) ✓
2. Login con credenciales incorrectas (401) ✓
3. Acceder a recurso inexistente (404) ✓
4. Crear cita con fecha inválida (400) ✓
5. Actualizar con ID inválido (400) ✓
```

---

## 📝 Tips para Postman

### 1. Organiza tus peticiones
- Usa carpetas para cada módulo
- Nombra las peticiones descriptivamente
- Agrega descripciones a cada petición

### 2. Guarda las respuestas
- Click derecho en una respuesta → "Save Response"
- Útil para comparar respuestas

### 3. Usa Tests
En la pestaña "Tests" de cada petición, puedes agregar:

```javascript
// Verificar status code
pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});

// Verificar respuesta exitosa
pm.test("Success is true", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.eql(true);
});

// Guardar ID en variable
var jsonData = pm.response.json();
pm.environment.set("negocio_id", jsonData.data.id);
```

### 4. Usa Pre-request Scripts
Para generar datos dinámicos:

```javascript
// Generar email único
var timestamp = Date.now();
pm.environment.set("unique_email", "user" + timestamp + "@example.com");
```

### 5. Documentación automática
- Agrega descripciones en cada petición
- Postman puede generar documentación web automáticamente

---

## ⚡ Atajos de Teclado en Postman

| Atajo | Acción |
|-------|--------|
| `Ctrl + Enter` | Enviar petición |
| `Ctrl + S` | Guardar petición |
| `Ctrl + K` | Buscar en colección |
| `Ctrl + N` | Nueva petición |
| `Ctrl + B` | Toggle sidebar |

---

## 🐛 Troubleshooting

### No puedo enviar peticiones
- ✓ Verifica que el servidor esté corriendo
- ✓ Revisa la URL (debe incluir `/api`)
- ✓ Verifica el Content-Type header

### Las respuestas son muy lentas
- ✓ Cierra otras aplicaciones pesadas
- ✓ Verifica tu conexión de red
- ✓ Reinicia el servidor

### No veo mis cambios
- ✓ Asegúrate de hacer click en "Save"
- ✓ Cierra y reabre Postman si es necesario

### Errores 500 constantemente
- ✓ Revisa los logs del servidor en la consola
- ✓ Verifica que la base de datos esté configurada
- ✓ Limpia y reconstruye: `.\gradlew.bat clean build`

---

## 📚 Recursos Adicionales

- **Documentación Completa:** Ver archivo `POSTMAN_API_GUIDE.md`
- **Logs del Servidor:** Revisa la consola donde ejecutaste `gradlew run`
- **Postman Learning Center:** https://learning.postman.com/

---

## ✅ Checklist de Configuración

Antes de empezar, verifica:

- [ ] Postman instalado
- [ ] Servidor corriendo en puerto 9090
- [ ] Colección importada en Postman
- [ ] Health check respondiendo correctamente
- [ ] Base de datos configurada

---

**¡Listo para empezar a probar la API! 🚀**

Para cualquier duda, consulta el archivo `POSTMAN_API_GUIDE.md` con la documentación completa.

