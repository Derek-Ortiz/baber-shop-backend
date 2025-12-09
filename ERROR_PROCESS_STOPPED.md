# 🔍 Diagnóstico: El Proceso Se Detuvo Inmediatamente

## ❌ El Problema

El deployment se completó pero el proceso de la API se detuvo inmediatamente:

```
✅ Servicio iniciado (PID: 8866)
❌ El proceso no está corriendo
```

Esto significa que la aplicación **intentó iniciarse pero falló** por algún error.

---

## 🎯 Verificación Inmediata (Hazlo AHORA)

### Paso 1: Conéctate a tu EC2

```bash
ssh -i tu-archivo.pem ubuntu@tu-ip-ec2
```

### Paso 2: Ver los Logs del Error

```bash
cd ~/barbershop-api
tail -n 100 app.log
```

O en tiempo real:
```bash
tail -f app.log
```

**Los logs te dirán EXACTAMENTE cuál es el problema.**

---

## 🐛 Errores Comunes y Soluciones

### Error 1: No Puede Conectar a MySQL

**En los logs verás:**
```
Connection refused: connect
SQLException: Communications link failure
Access denied for user 'BS'@'localhost'
```

**Solución:**

```bash
# Verificar que MySQL esté corriendo
sudo systemctl status mysql

# Si no está corriendo, iniciarlo
sudo systemctl start mysql

# Verificar credenciales
mysql -u BS -p
# Password: barbershop

# Si el usuario no existe, crearlo
mysql -u root -p
```

En MySQL:
```sql
CREATE DATABASE IF NOT EXISTS barbershop_db;
CREATE USER IF NOT EXISTS 'BS'@'localhost' IDENTIFIED BY 'barbershop';
GRANT ALL PRIVILEGES ON barbershop_db.* TO 'BS'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Luego reiniciar:
```bash
cd ~/barbershop-api
./start-service.sh
```

---

### Error 2: Puerto Ya en Uso

**En los logs verás:**
```
Address already in use
Failed to bind to 0.0.0.0:9090
```

**Solución:**

```bash
# Ver qué está usando el puerto
sudo lsof -i :9090

# Matar el proceso
sudo kill -9 PID_DEL_PROCESO

# Reiniciar
cd ~/barbershop-api
./start-service.sh
```

---

### Error 3: Falta Java o Versión Incorrecta

**En los logs verás:**
```
Error: A JNI error has occurred
Unsupported class file major version
```

**Solución:**

```bash
# Verificar versión de Java
java -version

# Debe ser Java 17 o superior
# Si no lo tienes, instalarlo:
sudo apt update
sudo apt install openjdk-17-jdk -y

# Verificar de nuevo
java -version
```

---

### Error 4: Archivo JAR Corrupto o Falta

**En los logs verás:**
```
Error: Unable to access jarfile
no main manifest attribute
```

**Solución:**

```bash
# Verificar que el JAR existe
ls -lh ~/barbershop-api/*.jar

# Si no existe o está vacío, recompilarlo localmente y subirlo
# O hacer otro push para que GitHub Actions lo genere de nuevo
```

---

### Error 5: Falta Archivo de Configuración

**En los logs verás:**
```
application.yaml not found
Could not find resource
```

**Solución:**

```bash
# Verificar que application.yaml existe
ls -lh ~/barbershop-api/application.yaml

# Si no existe, el JAR debe incluirlo en resources
# Verifica que el JAR se compiló correctamente
```

---

## 🔧 Script de Diagnóstico Automático

He creado un script que te dará toda la información:

```bash
# En tu EC2
cd ~/barbershop-api
chmod +x diagnose-error.sh
./diagnose-error.sh
```

Este script mostrará:
- ✅ Si el JAR existe
- 📝 Últimas 50 líneas del log
- ☕ Versión de Java
- 🗄️ Estado de MySQL
- 🌐 Puertos en uso
- 🔍 Procesos Java corriendo

---

## 🚀 Reintentar Manualmente

Una vez que identifiques y soluciones el problema:

```bash
cd ~/barbershop-api
./stop-service.sh
./start-service.sh
./check-status.sh
```

---

## 📊 Verificar que Funciona

Una vez que el servicio esté corriendo:

```bash
# Desde tu EC2
curl http://localhost:9090/api/health

# Desde tu computadora
curl http://TU-IP-EC2:9090/api/health
```

Deberías recibir:
```json
{
    "status": "OK",
    "message": "Barbershop API funcionando correctamente",
    "version": "1.0.0"
}
```

---

## 🔄 Próximo Deploy

He actualizado el workflow para que automáticamente:
1. ✅ Ejecute el script de diagnóstico
2. ✅ Muestre los logs en caso de error
3. ✅ Te dé información detallada del problema

En el próximo push, verás información mucho más detallada si algo falla.

---

## 📝 Pasos Inmediatos (HAZ ESTO)

1. **Conéctate a tu EC2:**
   ```bash
   ssh -i tu-archivo.pem ubuntu@tu-ip-ec2
   ```

2. **Ve los logs:**
   ```bash
   tail -n 100 ~/barbershop-api/app.log
   ```

3. **Identifica el error** (aparecerá en rojo o con "ERROR" o "Exception")

4. **Aplica la solución** según el error que veas arriba

5. **Reinicia el servicio:**
   ```bash
   cd ~/barbershop-api
   ./start-service.sh
   ```

6. **Verifica que funcione:**
   ```bash
   curl http://localhost:9090/api/health
   ```

---

## 💡 Causa Más Común

**El 90% de las veces el problema es MySQL:**
- MySQL no está corriendo
- El usuario 'BS' no existe
- La base de datos 'barbershop_db' no existe
- La contraseña es incorrecta

**Solución rápida:**

```bash
# Verificar MySQL
sudo systemctl status mysql
sudo systemctl start mysql

# Verificar usuario
mysql -u BS -pbarbershop -e "SHOW DATABASES;"

# Si falla, crear usuario
mysql -u root -p
```

```sql
CREATE DATABASE IF NOT EXISTS barbershop_db;
CREATE USER IF NOT EXISTS 'BS'@'localhost' IDENTIFIED BY 'barbershop';
GRANT ALL PRIVILEGES ON barbershop_db.* TO 'BS'@'localhost';
FLUSH PRIVILEGES;
```

```bash
# Reiniciar servicio
cd ~/barbershop-api
./start-service.sh
```

---

## 📞 Reportar el Error

Cuando veas los logs, copia el error y compártelo para ayudarte mejor.

El error estará en formato:
```
Exception in thread "main" ...
Caused by: ...
```

---

**ACCIÓN INMEDIATA:** Ve a tu EC2 y ejecuta `tail -n 100 ~/barbershop-api/app.log` para ver el error exacto. 🔍

