# 💈 BarberShop API - Backend Project

API REST para sistema de gestión de barberías y citas desarrollada con Ktor y Kotlin.

## 📋 Descripción

Sistema backend completo para gestionar barberías, clientes, administradores, servicios, horarios y citas. Incluye autenticación, CRUD completo y deployment automatizado a AWS EC2.

## ✨ Características

- ✅ **Autenticación** de clientes y administradores
- ✅ **Gestión de barberías** (CRUD completo)
- ✅ **Horarios** configurables por día
- ✅ **Servicios** con precios y duración
- ✅ **Sistema de citas** con estados
- ✅ **API REST** bien documentada
- ✅ **Deployment automático** con GitHub Actions
- ✅ **Base de datos MySQL**
- ✅ **Serialización JSON** con Kotlinx
- ✅ **CORS** habilitado para app móvil

## 🛠️ Tecnologías

- **Lenguaje:** Kotlin 1.9.x
- **Framework:** Ktor 2.3.x
- **Base de Datos:** MySQL 8.0
- **ORM:** Exposed
- **Serialización:** Kotlinx Serialization
- **Build Tool:** Gradle
- **Deployment:** GitHub Actions + AWS EC2

## 📂 Estructura del Proyecto

```
backend-BarberShop/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions workflow
├── scripts/
│   ├── start-service.sh        # Iniciar servicio
│   ├── stop-service.sh         # Detener servicio
│   ├── check-status.sh         # Ver estado
│   ├── install-service.sh      # Instalar como systemd
│   └── barbershop-api.service  # Archivo systemd
├── src/
│   └── main/
│       ├── kotlin/
│       │   ├── Application.kt
│       │   ├── config/         # Configuración de Ktor
│       │   ├── data/           # Tablas y repositorios
│       │   ├── domain/         # Servicios y modelos
│       │   └── routes/         # Endpoints de la API
│       └── resources/
│           └── application.yaml
├── DEPLOYMENT_GUIDE.md         # Guía de deployment
├── GITHUB_SECRETS_SETUP.md     # Configuración de secrets
├── POSTMAN_API_GUIDE.md        # Documentación completa de API
├── POSTMAN_QUICK_START.md      # Guía rápida de Postman
├── BarberShop_Postman_Collection.json
└── build.gradle.kts
```

## 🚀 Inicio Rápido

### Desarrollo Local

1. **Clonar el repositorio:**
```bash
git clone https://github.com/tu-usuario/backend-BarberShop.git
cd backend-BarberShop
```

2. **Configurar MySQL:**
```sql
CREATE DATABASE barbershop_db;
CREATE USER 'BS'@'localhost' IDENTIFIED BY 'barbershop';
GRANT ALL PRIVILEGES ON barbershop_db.* TO 'BS'@'localhost';
FLUSH PRIVILEGES;
```

3. **Ejecutar el servidor:**
```bash
./gradlew run
```

4. **Probar que funciona:**
```bash
curl http://localhost:9090/api/health
```

### Deployment en EC2

Ver guías detalladas:
- 📖 [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Guía completa de deployment
- 🔐 [GITHUB_SECRETS_SETUP.md](GITHUB_SECRETS_SETUP.md) - Configuración de secrets

**Resumen rápido:**

1. **Configurar 3 secrets en GitHub:**
   - `EC2_SSH_PRIVATE_KEY` - Tu clave privada .pem
   - `EC2_HOST` - IP o DNS de tu EC2
   - `EC2_USER` - Usuario SSH (generalmente `ubuntu`)

2. **Push a GitHub:**
```bash
git push origin main
```

3. **El deployment es automático** 🎉

## 📚 Documentación

### Documentación de API

- 📘 [POSTMAN_API_GUIDE.md](POSTMAN_API_GUIDE.md) - Documentación completa de todos los endpoints
- 🚀 [POSTMAN_QUICK_START.md](POSTMAN_QUICK_START.md) - Guía rápida para empezar
- 📦 [BarberShop_Postman_Collection.json](BarberShop_Postman_Collection.json) - Colección importable

### Base URL

**Desarrollo:**
```
http://localhost:9090/api
```

**Producción:**
```
http://tu-ip-ec2:9090/api
```

### Endpoints Principales

#### Autenticación
- `POST /api/auth/cliente/register` - Registrar cliente
- `POST /api/auth/cliente/login` - Login cliente
- `POST /api/auth/admin/register` - Registrar administrador
- `POST /api/auth/admin/login` - Login administrador

#### Negocios
- `GET /api/negocios` - Listar todas las barberías
- `GET /api/negocios/{id}` - Obtener barbería con horarios y servicios
- `POST /api/negocios` - Crear barbería
- `PUT /api/negocios/{id}` - Actualizar barbería
- `DELETE /api/negocios/{id}` - Eliminar barbería

#### Horarios
- `POST /api/horarios` - Agregar horario
- `PUT /api/horarios/{id}` - Actualizar horario
- `DELETE /api/horarios/{id}` - Eliminar horario

#### Servicios
- `POST /api/servicios` - Agregar servicio
- `PUT /api/servicios/{id}` - Actualizar servicio
- `DELETE /api/servicios/{id}` - Eliminar servicio

#### Citas
- `GET /api/citas/cliente/{id}` - Historial de citas del cliente
- `GET /api/citas/cliente/{id}/pendientes` - Citas pendientes
- `GET /api/citas/negocio/{id}` - Citas de una barbería
- `POST /api/citas` - Reservar cita
- `PATCH /api/citas/{id}/estado` - Actualizar estado
- `DELETE /api/citas/{id}` - Cancelar cita

**Total:** 22 endpoints documentados

## 🧪 Probar la API

### Con cURL

```bash
# Health check
curl http://localhost:9090/api/health

# Registrar cliente
curl -X POST http://localhost:9090/api/auth/cliente/register \
  -H "Content-Type: application/json" \
  -d '{
    "nombres": "Juan",
    "apellidoP": "Pérez",
    "apellidoM": "García",
    "telefono": "5551234567",
    "email": "juan@example.com",
    "contraseña": "pass123",
    "direccion": "Calle #123"
  }'
```

### Con Postman

1. Importa `BarberShop_Postman_Collection.json`
2. Sigue la guía en `POSTMAN_QUICK_START.md`

## 🗄️ Base de Datos

### Tablas

- `clientes` - Clientes del sistema
- `administradores` - Administradores de barberías
- `negocios` - Barberías registradas
- `horarios` - Horarios de atención
- `servicios` - Servicios ofrecidos
- `citas` - Reservas de citas

### Configuración

```yaml
database:
  url: jdbc:mysql://localhost:3306/barbershop_db
  driver: com.mysql.cj.jdbc.Driver
  user: BS
  password: barbershop
```

## 🔧 Variables de Entorno

Copia `.env.example` a `.env` y ajusta los valores:

```bash
# Servidor
PORT=9090
HOST=0.0.0.0

# Base de Datos
DB_URL=jdbc:mysql://localhost:3306/barbershop_db
DB_USER=BS
DB_PASSWORD=barbershop
```

## 🐛 Troubleshooting

### Error: Connection refused

**Problema:** No puedes conectarte a la API

**Solución:**
```bash
# Verifica que el servidor esté corriendo
./gradlew run

# O en producción
./scripts/check-status.sh
```

### Error: Access denied for user

**Problema:** No puede conectarse a MySQL

**Solución:**
```sql
-- Crear usuario y dar permisos
CREATE USER 'BS'@'localhost' IDENTIFIED BY 'barbershop';
GRANT ALL PRIVILEGES ON barbershop_db.* TO 'BS'@'localhost';
FLUSH PRIVILEGES;
```

### Error 404: Not Found

**Problema:** Todos los endpoints dan 404

**Solución:** Recuerda usar el prefijo `/api`:
```bash
# ❌ Incorrecto
curl http://localhost:9090/health

# ✅ Correcto
curl http://localhost:9090/api/health
```

## 📈 Monitoreo

### Ver logs en tiempo real

**Desarrollo:**
```bash
# Los logs aparecen en la consola donde ejecutaste gradlew run
```

**Producción:**
```bash
# Logs del script
tail -f ~/barbershop-api/app.log

# Logs de systemd
sudo journalctl -u barbershop-api -f
```

### Verificar estado

```bash
# En producción
cd ~/barbershop-api
./check-status.sh
```

## 🔐 Seguridad

### Para Desarrollo
- ✅ Credenciales de BD en variables de entorno
- ✅ CORS configurado
- ✅ Validación de datos de entrada

### Para Producción
- ⚠️ Configurar HTTPS/SSL
- ⚠️ Usar contraseñas fuertes
- ⚠️ Restringir acceso SSH
- ⚠️ Implementar rate limiting
- ⚠️ Agregar autenticación JWT

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto es parte de un proyecto académico.

## 👥 Autores

- Backend Team - BarberShop Project

## 📞 Soporte

Para soporte, consulta:
- 📖 [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- 📘 [POSTMAN_API_GUIDE.md](POSTMAN_API_GUIDE.md)
- 🔐 [GITHUB_SECRETS_SETUP.md](GITHUB_SECRETS_SETUP.md)

## 🎯 Roadmap

- [x] API REST completa
- [x] Autenticación básica
- [x] CRUD de todos los recursos
- [x] Deployment automático
- [x] Documentación completa
- [ ] Autenticación JWT
- [ ] Upload de imágenes
- [ ] Notificaciones push
- [ ] Sistema de ratings
- [ ] Reportes y analytics

---

**Versión:** 1.0.0  
**Última actualización:** 2025-12-09  
**Puerto:** 9090  
**Base URL:** http://localhost:9090/api

**¡Listo para usar! 🚀**

