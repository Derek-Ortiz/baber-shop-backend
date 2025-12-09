# 🚀 Guía de Deployment - BarberShop API en EC2

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Configuración de GitHub Secrets](#configuración-de-github-secrets)
3. [Preparación de la Instancia EC2](#preparación-de-la-instancia-ec2)
4. [Despliegue Automático](#despliegue-automático)
5. [Despliegue Manual](#despliegue-manual)
6. [Comandos Útiles](#comandos-útiles)
7. [Troubleshooting](#troubleshooting)

---

## 📦 Requisitos Previos

### En tu Instancia EC2:

- ✅ **Ubuntu Server** (20.04 o superior)
- ✅ **Java 17** o superior instalado
- ✅ **MySQL** configurado y corriendo
- ✅ **Base de datos** `barbershop_db` creada
- ✅ **Usuario MySQL** `BS` con contraseña `barbershop`
- ✅ **Puertos abiertos**: 9090 y 8080
- ✅ **SSH** configurado con key pair

### En tu Repositorio GitHub:

- ✅ Repositorio creado y código subido
- ✅ Secrets configurados (ver siguiente sección)

---

## 🔐 Configuración de GitHub Secrets

Necesitas configurar **3 secrets** en tu repositorio de GitHub:

### Paso 1: Ir a Settings → Secrets and variables → Actions

En tu repositorio de GitHub:
1. Click en **Settings**
2. En el menú lateral, click en **Secrets and variables**
3. Click en **Actions**
4. Click en **New repository secret**

### Paso 2: Agregar los Secrets

#### Secret 1: `EC2_SSH_PRIVATE_KEY`

**Valor:** La clave privada SSH completa para conectarte a tu EC2

```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
(todo el contenido de tu archivo .pem)
...
-----END RSA PRIVATE KEY-----
```

**Cómo obtenerla:**
- Es el archivo `.pem` que descargaste al crear tu instancia EC2
- En Windows: Abre el archivo con Notepad y copia todo el contenido
- En Linux/Mac: `cat tu-archivo.pem` y copia todo

**⚠️ IMPORTANTE:** 
- Copia TODO el contenido, incluyendo las líneas BEGIN y END
- NO agregues espacios extra al inicio o final
- NO compartas este secret con nadie

---

#### Secret 2: `EC2_HOST`

**Valor:** La dirección IP pública o DNS de tu instancia EC2

**Ejemplos:**
```
ec2-18-234-123-456.compute-1.amazonaws.com
```
O simplemente la IP:
```
18.234.123.456
```

**Cómo obtenerla:**
1. Ve a la consola de AWS EC2
2. Selecciona tu instancia
3. Copia el valor de "Public IPv4 address" o "Public IPv4 DNS"

---

#### Secret 3: `EC2_USER`

**Valor:** El usuario SSH para conectarte a tu EC2

**Para Ubuntu:**
```
ubuntu
```

**Para Amazon Linux:**
```
ec2-user
```

**Nota:** En la mayoría de casos con Ubuntu Server es `ubuntu`

---

### Resumen de Secrets Requeridos

| Secret Name | Descripción | Ejemplo |
|------------|-------------|---------|
| `EC2_SSH_PRIVATE_KEY` | Clave privada SSH completa | `-----BEGIN RSA PRIVATE KEY-----\nMIIE...` |
| `EC2_HOST` | IP o DNS de tu EC2 | `18.234.123.456` |
| `EC2_USER` | Usuario SSH | `ubuntu` |

---

## 🖥️ Preparación de la Instancia EC2

### Paso 1: Conectarse a tu EC2

```bash
ssh -i tu-archivo.pem ubuntu@tu-ip-ec2
```

### Paso 2: Instalar Java 17

```bash
# Actualizar el sistema
sudo apt update
sudo apt upgrade -y

# Instalar Java 17
sudo apt install openjdk-17-jdk -y

# Verificar instalación
java -version
```

**Salida esperada:**
```
openjdk version "17.0.x" ...
```

### Paso 3: Verificar MySQL

```bash
# Verificar que MySQL esté corriendo
sudo systemctl status mysql

# Conectarse a MySQL
mysql -u BS -p
# Ingresa la contraseña: barbershop
```

En MySQL, verifica la base de datos:
```sql
SHOW DATABASES;
USE barbershop_db;
SHOW TABLES;
EXIT;
```

### Paso 4: Configurar Firewall (Security Group)

En la consola de AWS:

1. Ve a **EC2 → Security Groups**
2. Selecciona el Security Group de tu instancia
3. Agrega estas reglas de entrada (Inbound Rules):

| Type | Protocol | Port Range | Source | Description |
|------|----------|------------|--------|-------------|
| Custom TCP | TCP | 9090 | 0.0.0.0/0 | BarberShop API |
| Custom TCP | TCP | 8080 | 0.0.0.0/0 | BarberShop API Alt |
| SSH | TCP | 22 | Tu IP | SSH Access |

**⚠️ Importante:** 
- Para producción, restringe el acceso SSH solo a tu IP
- Los puertos 9090 y 8080 deben estar abiertos para que tu app móvil pueda acceder

### Paso 5: Crear Directorio de la Aplicación

```bash
# Crear directorio
mkdir -p ~/barbershop-api

# Verificar
ls -la ~/barbershop-api
```

---

## 🔄 Despliegue Automático (GitHub Actions)

### Cómo Funciona

Cada vez que hagas `push` a la rama `main` o `master`, GitHub Actions:

1. ✅ Descarga el código
2. ✅ Compila el proyecto con Gradle
3. ✅ Crea el archivo JAR
4. ✅ Se conecta a tu EC2 por SSH
5. ✅ Copia los archivos al servidor
6. ✅ Detiene la versión anterior
7. ✅ Inicia la nueva versión
8. ✅ Verifica que esté funcionando

### Para Activar el Deployment

```bash
# En tu computadora, desde el directorio del proyecto

# 1. Asegúrate de tener los últimos cambios
git pull

# 2. Haz tus cambios y commit
git add .
git commit -m "Actualización de la API"

# 3. Push a GitHub (esto activa el workflow)
git push origin main
```

### Monitorear el Deployment

1. Ve a tu repositorio en GitHub
2. Click en la pestaña **Actions**
3. Verás el workflow ejecutándose
4. Click en el workflow para ver detalles y logs

**Tiempo estimado:** 2-5 minutos

### Verificar que Funciona

Una vez completado el workflow:

```bash
# Desde tu computadora
curl http://TU-IP-EC2:9090/api/health
```

**Respuesta esperada:**
```json
{
    "status": "OK",
    "message": "Barbershop API funcionando correctamente",
    "version": "1.0.0"
}
```

---

## 🔨 Despliegue Manual

Si prefieres desplegar manualmente o necesitas depurar:

### Opción 1: Usando el Script de Inicio

```bash
# Conectarse a EC2
ssh -i tu-archivo.pem ubuntu@tu-ip-ec2

# Navegar al directorio
cd ~/barbershop-api

# Ejecutar script de inicio
./start-service.sh
```

### Opción 2: Compilar y Desplegar Manualmente

**En tu computadora:**

```bash
# 1. Compilar el proyecto
./gradlew build

# 2. Copiar el JAR a EC2
scp -i tu-archivo.pem build/libs/*.jar ubuntu@tu-ip-ec2:~/barbershop-api/

# 3. Copiar scripts
scp -i tu-archivo.pem scripts/*.sh ubuntu@tu-ip-ec2:~/barbershop-api/
```

**En tu EC2:**

```bash
# Conectarse
ssh -i tu-archivo.pem ubuntu@tu-ip-ec2

# Dar permisos a los scripts
cd ~/barbershop-api
chmod +x *.sh

# Iniciar el servicio
./start-service.sh
```

### Opción 3: Instalar como Servicio Systemd

Para que la aplicación se inicie automáticamente al reiniciar el servidor:

```bash
# En tu EC2
cd ~/barbershop-api

# Copiar el archivo de servicio
sudo cp scripts/barbershop-api.service /etc/systemd/system/

# Editar el archivo si es necesario (ajustar rutas del usuario)
sudo nano /etc/systemd/system/barbershop-api.service

# Recargar systemd
sudo systemctl daemon-reload

# Habilitar el servicio
sudo systemctl enable barbershop-api

# Iniciar el servicio
sudo systemctl start barbershop-api

# Verificar estado
sudo systemctl status barbershop-api
```

**Comandos systemd:**
```bash
# Iniciar
sudo systemctl start barbershop-api

# Detener
sudo systemctl stop barbershop-api

# Reiniciar
sudo systemctl restart barbershop-api

# Ver logs
sudo journalctl -u barbershop-api -f
```

---

## 🛠️ Comandos Útiles

### Scripts Disponibles

Todos estos scripts están en `~/barbershop-api/`:

#### 1. Iniciar el Servicio
```bash
./start-service.sh
```
Detiene cualquier instancia anterior e inicia una nueva.

#### 2. Detener el Servicio
```bash
./stop-service.sh
```
Detiene el servicio actual.

#### 3. Verificar Estado
```bash
./check-status.sh
```
Muestra información completa sobre el estado del servicio.

### Comandos de Monitoreo

#### Ver Logs en Tiempo Real
```bash
tail -f ~/barbershop-api/app.log
```

#### Ver Últimas 100 Líneas de Log
```bash
tail -n 100 ~/barbershop-api/app.log
```

#### Buscar Errores en Logs
```bash
grep ERROR ~/barbershop-api/app.log
```

#### Ver Procesos Java
```bash
ps aux | grep java
```

#### Ver Qué Está Usando el Puerto 9090
```bash
sudo lsof -i :9090
```

#### Verificar Memoria y CPU
```bash
top
# Presiona 'q' para salir
```

### Comandos de Red

#### Verificar que el Puerto Está Abierto
```bash
netstat -tlnp | grep 9090
```

#### Probar Endpoint Localmente
```bash
curl http://localhost:9090/api/health
```

#### Probar Endpoint Externamente (desde tu computadora)
```bash
curl http://TU-IP-EC2:9090/api/health
```

---

## 🐛 Troubleshooting

### Problema 1: El Workflow de GitHub Falla

**Síntoma:** El workflow en GitHub Actions muestra errores rojos

**Causas Comunes:**

1. **Secrets incorrectos o faltantes**
   - Verifica que los 3 secrets estén configurados
   - Verifica que no haya espacios extra en los secrets

2. **Clave SSH incorrecta**
   - Asegúrate de copiar toda la clave privada
   - Incluye las líneas BEGIN y END

3. **Host o User incorrectos**
   - Verifica la IP o DNS de tu EC2
   - Para Ubuntu usa `ubuntu`, para Amazon Linux usa `ec2-user`

**Solución:**
```bash
# Ve a Settings → Secrets en GitHub
# Verifica cada secret
# Re-créalos si es necesario
```

---

### Problema 2: No Puedo Conectarme por SSH

**Síntoma:** `Connection refused` o `Connection timed out`

**Solución:**

1. **Verifica el Security Group:**
   ```
   EC2 → Security Groups → Inbound Rules
   Debe tener: SSH (22) desde tu IP
   ```

2. **Verifica que la instancia esté corriendo:**
   ```
   EC2 → Instances → Estado debe ser "running"
   ```

3. **Verifica la clave SSH:**
   ```bash
   # En Windows
   ssh -i ruta\a\tu\archivo.pem ubuntu@ip-ec2
   
   # En Linux/Mac
   chmod 400 tu-archivo.pem
   ssh -i tu-archivo.pem ubuntu@ip-ec2
   ```

---

### Problema 3: La API No Responde en el Puerto 9090

**Síntoma:** `curl` devuelve `Connection refused`

**Diagnóstico:**

```bash
# En tu EC2
cd ~/barbershop-api

# 1. Verificar si el proceso está corriendo
./check-status.sh

# 2. Ver logs
tail -n 50 app.log

# 3. Verificar puerto
sudo lsof -i :9090
```

**Causas Comunes:**

1. **El servicio no está corriendo**
   ```bash
   ./start-service.sh
   ```

2. **Error en la aplicación (ver logs)**
   ```bash
   tail -f app.log
   ```

3. **Puerto bloqueado**
   - Verifica Security Group en AWS
   - Debe permitir tráfico TCP en puerto 9090 desde 0.0.0.0/0

4. **Otro proceso usando el puerto**
   ```bash
   # Ver qué está usando el puerto
   sudo lsof -i :9090
   
   # Matar el proceso
   sudo kill -9 PID_DEL_PROCESO
   
   # Reiniciar
   ./start-service.sh
   ```

---

### Problema 4: Error de Conexión a Base de Datos

**Síntoma:** En los logs aparece `Connection refused` o `Access denied`

**Solución:**

```bash
# 1. Verificar que MySQL esté corriendo
sudo systemctl status mysql

# Si no está corriendo
sudo systemctl start mysql

# 2. Verificar credenciales
mysql -u BS -p
# Contraseña: barbershop

# 3. Si el usuario no existe, crearlo:
mysql -u root -p
```

En MySQL:
```sql
CREATE USER IF NOT EXISTS 'BS'@'localhost' IDENTIFIED BY 'barbershop';
GRANT ALL PRIVILEGES ON barbershop_db.* TO 'BS'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
# 4. Verificar que la base de datos existe
mysql -u BS -p -e "SHOW DATABASES;"

# Si no existe, crearla
mysql -u BS -p -e "CREATE DATABASE IF NOT EXISTS barbershop_db;"
```

---

### Problema 5: El Servicio Se Detiene Solo

**Síntoma:** El servicio funciona pero después de un tiempo se detiene

**Solución:** Instalar como servicio systemd

```bash
cd ~/barbershop-api
sudo chmod +x scripts/install-service.sh
cd scripts
sudo ./install-service.sh
```

Esto hará que:
- ✅ El servicio se inicie automáticamente al arrancar el servidor
- ✅ Se reinicie automáticamente si falla
- ✅ Los logs se manejen correctamente

---

### Problema 6: Error 404 en Todos los Endpoints

**Síntoma:** La API responde pero todos los endpoints dan 404

**Causa:** Probablemente estás olvidando el prefijo `/api`

**Solución:**
```bash
# ❌ Incorrecto
curl http://TU-IP:9090/health

# ✅ Correcto
curl http://TU-IP:9090/api/health
```

Todos los endpoints tienen el prefijo `/api`:
- `/api/health`
- `/api/auth/cliente/register`
- `/api/negocios`
- etc.

---

### Problema 7: Memoria Insuficiente

**Síntoma:** La aplicación se vuelve lenta o se detiene

**Solución:**

```bash
# Ver uso de memoria
free -h

# Si tienes poca memoria, agrega swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Para que persista después de reiniciar
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 🎯 Checklist de Deployment

Antes de desplegar, verifica:

### En AWS EC2:
- [ ] Instancia está corriendo
- [ ] Java 17 instalado
- [ ] MySQL instalado y corriendo
- [ ] Base de datos `barbershop_db` creada
- [ ] Usuario `BS` con contraseña `barbershop` creado
- [ ] Puertos 9090 y 8080 abiertos en Security Group
- [ ] Puerto 22 (SSH) abierto desde tu IP

### En GitHub:
- [ ] Repositorio creado
- [ ] Código subido
- [ ] Secret `EC2_SSH_PRIVATE_KEY` configurado
- [ ] Secret `EC2_HOST` configurado
- [ ] Secret `EC2_USER` configurado

### En tu Código:
- [ ] Archivo `application.yaml` configurado
- [ ] Scripts tienen permisos de ejecución
- [ ] `.gitignore` actualizado
- [ ] Workflow `.github/workflows/deploy.yml` presente

---

## 📱 Probando desde la App Móvil

Una vez desplegado, tu app móvil debe usar:

```kotlin
// Base URL
const val BASE_URL = "http://TU-IP-EC2:9090/api/"

// Ejemplos de endpoints
// http://18.234.123.456:9090/api/auth/cliente/register
// http://18.234.123.456:9090/api/negocios
// http://18.234.123.456:9090/api/citas
```

**⚠️ Importante:** 
- Reemplaza `TU-IP-EC2` con tu IP real
- Usa HTTP (no HTTPS) a menos que configures certificado SSL
- Para producción, considera usar un dominio y SSL

---

## 🔒 Mejores Prácticas de Seguridad

### Para Desarrollo:
1. ✅ Usa Security Groups para restringir acceso
2. ✅ NO expongas la base de datos directamente
3. ✅ Usa variables de entorno para credenciales
4. ✅ NO subas claves privadas al repositorio

### Para Producción:
1. ✅ Configura SSL/HTTPS con Let's Encrypt
2. ✅ Usa un dominio en lugar de IP
3. ✅ Implementa rate limiting
4. ✅ Agrega autenticación con JWT
5. ✅ Configura backups automáticos de la BD
6. ✅ Usa AWS RDS en lugar de MySQL local
7. ✅ Configura CloudWatch para monitoreo

---

## 📞 Soporte

Si tienes problemas:

1. **Revisa los logs:**
   ```bash
   tail -f ~/barbershop-api/app.log
   ```

2. **Verifica el estado:**
   ```bash
   ./check-status.sh
   ```

3. **Revisa el workflow en GitHub:**
   - GitHub → Actions → Ver detalles del workflow

4. **Consulta esta documentación:**
   - `POSTMAN_API_GUIDE.md` para referencia de API
   - `DEPLOYMENT_GUIDE.md` (este archivo) para deployment

---

**Última actualización:** 2025-12-09  
**Versión:** 1.0.0

