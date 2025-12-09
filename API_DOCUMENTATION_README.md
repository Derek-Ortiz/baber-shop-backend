# 📖 Documentación de API - BarberShop Backend

## 📂 Archivos de Documentación

Este proyecto incluye **3 archivos** de documentación para facilitar el uso y prueba de la API:

### 1. 📘 `POSTMAN_API_GUIDE.md` - Guía Completa
**Archivo principal con toda la documentación de la API**

**Contenido:**
- ✅ Todos los endpoints documentados en detalle
- ✅ Parámetros requeridos y opcionales
- ✅ Ejemplos de peticiones y respuestas
- ✅ Códigos de error y soluciones
- ✅ Flujos de uso típicos
- ✅ Troubleshooting completo

**Úsalo cuando:**
- Necesites entender cómo funciona un endpoint
- Quieras ver ejemplos de respuestas
- Necesites resolver errores
- Quieras conocer todos los endpoints disponibles

---

### 2. 🚀 `POSTMAN_QUICK_START.md` - Inicio Rápido
**Guía rápida para empezar a usar Postman inmediatamente**

**Contenido:**
- ✅ Cómo importar la colección en Postman
- ✅ Orden recomendado de pruebas
- ✅ Setup paso a paso
- ✅ Variables de entorno
- ✅ Tips y atajos de Postman
- ✅ Checklist de configuración

**Úsalo cuando:**
- Sea tu primera vez usando la API
- Quieras configurar Postman rápidamente
- Necesites un flujo de prueba guiado

---

### 3. 📦 `BarberShop_Postman_Collection.json` - Colección Importable
**Colección de Postman lista para importar**

**Contenido:**
- ✅ Todas las peticiones pre-configuradas
- ✅ Headers correctos
- ✅ Ejemplos de body JSON
- ✅ URLs correctas
- ✅ Organizado por módulos

**Úsalo cuando:**
- Quieras empezar a probar inmediatamente
- No quieras escribir las peticiones manualmente
- Necesites tener todas las peticiones organizadas

**Cómo usarlo:**
1. Abre Postman
2. Click en "Import"
3. Selecciona este archivo
4. ¡Listo! Todas las peticiones estarán disponibles

---

## 🎯 ¿Por Dónde Empezar?

### Si es tu primera vez:

1. **Lee:** `POSTMAN_QUICK_START.md` (5 minutos)
2. **Importa:** `BarberShop_Postman_Collection.json` en Postman
3. **Sigue:** La guía paso a paso en Quick Start
4. **Consulta:** `POSTMAN_API_GUIDE.md` cuando tengas dudas

### Si ya conoces Postman:

1. **Importa:** `BarberShop_Postman_Collection.json`
2. **Consulta:** `POSTMAN_API_GUIDE.md` como referencia
3. **Empieza a probar** los endpoints

### Si eres desarrollador:

1. **Lee:** `POSTMAN_API_GUIDE.md` completo
2. **Usa:** `BarberShop_Postman_Collection.json` para pruebas rápidas
3. **Consulta:** Los modelos de datos en el código fuente

---

## 🌐 Información Rápida

### Base URL
```
http://localhost:9090/api
```

### Puerto del Servidor
```
9090
```

### Headers Necesarios (POST/PUT/PATCH)
```
Content-Type: application/json
```

### Verificar que el servidor funciona
```
GET http://localhost:9090/api/health
```

---

## 📊 Resumen de Endpoints

### 🔐 Autenticación (4 endpoints)
- Registro Admin
- Login Admin
- Registro Cliente
- Login Cliente

### 🏢 Negocios (5 endpoints)
- Listar todas
- Obtener completa
- Crear
- Actualizar
- Eliminar

### 🕒 Horarios (3 endpoints)
- Agregar
- Actualizar
- Eliminar

### 💇 Servicios (3 endpoints)
- Agregar
- Actualizar
- Eliminar

### 📅 Citas (6 endpoints)
- Historial cliente
- Pendientes cliente
- Historial negocio
- Reservar
- Actualizar estado
- Cancelar

**Total: 21 endpoints + 1 health check**

---

## 🚀 Inicio Rápido (30 segundos)

### 1. Inicia el servidor
```powershell
cd "C:\Users\Derek\Desktop\Proyecto-moviles\Backend-project-1.0\backend-BarberShop"
.\gradlew.bat run
```

### 2. Verifica que funciona
```
GET http://localhost:9090/api/health
```

### 3. Importa la colección en Postman
- Archivo: `BarberShop_Postman_Collection.json`

### 4. ¡Empieza a probar!
- Primera prueba: Registro de Cliente o Admin

---

## 📚 Ejemplos Rápidos

### Registrar un Cliente
```bash
POST http://localhost:9090/api/auth/cliente/register

{
    "nombres": "Juan",
    "apellidoP": "Pérez",
    "apellidoM": "García",
    "telefono": "5551234567",
    "email": "juan@example.com",
    "contraseña": "pass123",
    "direccion": "Calle #123"
}
```

### Crear una Barbería
```bash
POST http://localhost:9090/api/negocios

{
    "nombreN": "Mi Barbería",
    "direccion": "Av. Principal #100"
}
```

### Reservar una Cita
```bash
POST http://localhost:9090/api/citas

{
    "fechaCita": "2025-12-20",
    "asunto": "Corte de cabello",
    "clienteId": 1,
    "negocioId": 1,
    "servicioId": 1
}
```

---

## 🔧 Troubleshooting Rápido

### Error 404
❌ **Problema:** URL incorrecta  
✅ **Solución:** Asegúrate de incluir `/api` en la URL

### Error 400 sin feedback
❌ **Problema:** Falta Content-Type header  
✅ **Solución:** Agrega `Content-Type: application/json`

### Connection Refused
❌ **Problema:** Servidor no está corriendo  
✅ **Solución:** Ejecuta `.\gradlew.bat run`

### Error 500
❌ **Problema:** Error del servidor  
✅ **Solución:** Revisa los logs en la consola

---

## 📞 Estructura de Respuestas

### Éxito
```json
{
    "success": true,
    "message": "Descripción del éxito",
    "data": { ... }
}
```

### Error
```json
{
    "success": false,
    "message": "Descripción del error"
}
```

---

## 🎓 Recursos de Aprendizaje

1. **Para usar la API:**
   - Lee `POSTMAN_QUICK_START.md`
   - Consulta `POSTMAN_API_GUIDE.md`

2. **Para entender el código:**
   - Revisa los archivos en `src/main/kotlin/routes/`
   - Revisa los modelos en `src/main/kotlin/domain/services/models/`

3. **Para hacer cambios:**
   - Documenta los cambios en estos archivos
   - Actualiza la colección de Postman si es necesario

---

## ✅ Checklist Pre-Uso

Antes de empezar a probar, verifica:

- [ ] Servidor corriendo (puerto 9090)
- [ ] Postman instalado
- [ ] Colección importada
- [ ] Health check funcionando
- [ ] Tienes los 3 archivos de documentación

---

## 📝 Notas Importantes

1. **Puerto:** El servidor corre en el puerto **9090** (no 8080)
2. **Base URL:** Todas las rutas empiezan con `/api`
3. **Fechas:** Formato `YYYY-MM-DD` (ejemplo: "2025-12-20")
4. **Horas:** Formato `HH:mm:ss` (ejemplo: "09:00:00")
5. **IDs:** Se generan automáticamente, no los incluyas en POST

---

## 🎉 ¡Todo Listo!

Tienes toda la documentación necesaria para empezar a usar la API de BarberShop.

**Siguiente paso:** Abre `POSTMAN_QUICK_START.md` y sigue la guía paso a paso.

**¿Dudas?** Consulta `POSTMAN_API_GUIDE.md` para información detallada.

**¿Listo para probar?** Importa `BarberShop_Postman_Collection.json` en Postman.

---

**Versión:** 1.0.0  
**Fecha:** 2025-12-09  
**Autor:** Backend Team - BarberShop Project

