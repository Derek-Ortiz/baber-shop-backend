# 🔧 Solución: Error "Load key private_key.pem: error in libcrypto"

## ❌ El Problema

```
Load key "private_key.pem": error in libcrypto
Permission denied (publickey).
Error: Process completed with exit code 255.
```

Este error indica que la clave SSH privada no se está leyendo correctamente. Causas comunes:
1. La clave tiene formato incorrecto
2. Hay caracteres de nueva línea incorrectos
3. El secret está mal configurado en GitHub

---

## ✅ Solución Aplicada

He actualizado el workflow para:
1. Eliminar caracteres de retorno de carro (`\r`) que causan problemas
2. Verificar que la clave se creó correctamente antes de usarla
3. Validar que el archivo no esté vacío

---

## 🔍 Verificar tu Secret de Clave SSH

### Paso 1: Verificar el Formato de tu Clave

Tu archivo `.pem` debe verse exactamente así:

```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAxxx...
(varias líneas de texto base64)
...xxxxx
-----END RSA PRIVATE KEY-----
```

O para claves más nuevas:

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAA...
(varias líneas de texto base64)
...xxxxx
-----END OPENSSH PRIVATE KEY-----
```

### Paso 2: Re-crear el Secret en GitHub

Si el error persiste, necesitas **eliminar y volver a crear** el secret:

#### En Windows:

1. **Abre tu archivo .pem con Notepad++** (NO uses Notepad normal)
2. Ve a `Edit` → `EOL Conversion` → `Unix (LF)`
3. Copia TODO el contenido (Ctrl+A, Ctrl+C)
4. Ve a GitHub → Settings → Secrets → Actions
5. **Elimina** el secret `EC2_SSH_PRIVATE_KEY` existente
6. Click en "New repository secret"
7. Nombre: `EC2_SSH_PRIVATE_KEY`
8. Pega el contenido (Ctrl+V)
9. Click "Add secret"

#### En Linux/Mac:

```bash
# Ver el contenido de tu clave
cat tu-archivo.pem

# Copiar al portapapeles
cat tu-archivo.pem | pbcopy  # Mac
cat tu-archivo.pem | xclip   # Linux
```

Luego:
1. Ve a GitHub → Settings → Secrets → Actions
2. **Elimina** el secret `EC2_SSH_PRIVATE_KEY` existente
3. Click en "New repository secret"
4. Nombre: `EC2_SSH_PRIVATE_KEY`
5. Pega el contenido
6. Click "Add secret"

---

## 🔐 Verificación del Secret

### Checklist del Secret Correcto:

- [ ] Incluye la línea `-----BEGIN RSA PRIVATE KEY-----` o `-----BEGIN OPENSSH PRIVATE KEY-----`
- [ ] Incluye la línea `-----END RSA PRIVATE KEY-----` o `-----END OPENSSH PRIVATE KEY-----`
- [ ] Tiene varias líneas de texto en medio
- [ ] NO tiene espacios al inicio o final
- [ ] NO tiene líneas en blanco extra al inicio o final
- [ ] NO tiene caracteres raros o ñ incorrectos

### Ejemplo de Secret CORRECTO:

```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAy8Dbv8prpJ/0k1234567890abcdefghijklmnopqrstuvwxyz
AQABAAABAQC5JSQPK1234567890abcdefghijklmnopqrstuvwxyzABCDEFGH
... (más líneas)
1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
-----END RSA PRIVATE KEY-----
```

### Ejemplo de Secret INCORRECTO:

❌ Le faltan las líneas BEGIN/END:
```
MIIEpAIBAAKCAQEAy8Dbv8prpJ/0k1234567890...
```

❌ Tiene espacios extra:
```
  -----BEGIN RSA PRIVATE KEY-----
  MIIEpAIBAAKCAQEAy8Dbv8prpJ...
  -----END RSA PRIVATE KEY-----
```

❌ Tiene líneas en blanco:
```

-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAy8Dbv8prpJ...
-----END RSA PRIVATE KEY-----

```

---

## 🧪 Probar la Clave Localmente

Antes de usarla en GitHub Actions, prueba que funcione localmente:

```bash
# En tu computadora

# 1. Verificar permisos
chmod 600 tu-archivo.pem

# 2. Probar conexión SSH
ssh -i tu-archivo.pem ubuntu@tu-ip-ec2

# Si funciona, entonces la clave es válida
```

Si la conexión funciona localmente pero falla en GitHub Actions, el problema es cómo está configurado el secret.

---

## 🔄 Alternativa: Usar un Formato Diferente

Si el problema persiste, puedes convertir tu clave a formato base64:

### Opción 1: Base64 (Más Confiable)

**En tu computadora:**

```bash
# Linux/Mac
cat tu-archivo.pem | base64 | tr -d '\n'

# Windows PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("tu-archivo.pem"))
```

**Actualizar el workflow:**

En el archivo `.github/workflows/deploy.yml`, cambia esta línea:

```yaml
# ANTES
echo "$PRIVATE_KEY" | tr -d '\r' > private_key.pem

# DESPUÉS
echo "$PRIVATE_KEY" | base64 -d > private_key.pem
```

Y en GitHub, guarda el secret con el valor base64 que obtuviste.

---

## 📝 Guía Paso a Paso Completa

### 1. Preparar la Clave

**Windows:**
```powershell
# Abrir PowerShell
cd C:\Users\TuUsuario\Downloads
notepad++ tu-archivo.pem
# Edit → EOL Conversion → Unix (LF)
# Ctrl+A, Ctrl+C
```

**Linux/Mac:**
```bash
cat ~/Downloads/tu-archivo.pem
# Copiar el contenido
```

### 2. Eliminar el Secret Antiguo

1. Ve a tu repositorio en GitHub
2. Click en **Settings**
3. **Secrets and variables** → **Actions**
4. Busca `EC2_SSH_PRIVATE_KEY`
5. Click en **Remove** → Confirmar

### 3. Crear el Nuevo Secret

1. Click en **New repository secret**
2. Name: `EC2_SSH_PRIVATE_KEY`
3. Secret: Pegar el contenido de tu .pem
4. Click **Add secret**

### 4. Verificar los Otros Secrets

Mientras estás ahí, verifica:

**EC2_HOST:**
```
18.234.123.456
```
O
```
ec2-18-234-123-456.compute-1.amazonaws.com
```

**EC2_USER:**
```
ubuntu
```

### 5. Hacer Push para Probar

```bash
git add .
git commit -m "Fix SSH key format"
git push origin main
```

### 6. Monitorear el Workflow

1. Ve a GitHub → **Actions**
2. Click en el workflow que se está ejecutando
3. Observa los logs en tiempo real
4. Si falla, mira el mensaje de error específico

---

## 🐛 Otros Errores Comunes

### Error: "Host key verification failed"

**Solución:** El workflow ya incluye `-o StrictHostKeyChecking=no`, pero verifica que tu `EC2_HOST` sea correcto.

### Error: "Permission denied (publickey)" (después de fix)

**Posibles causas:**
1. La clave no corresponde a la instancia EC2
2. El usuario es incorrecto (verifica que sea `ubuntu` o `ec2-user`)
3. La clave pública no está en `~/.ssh/authorized_keys` en el EC2

**Solución:**
```bash
# Conectarte a tu EC2 manualmente
ssh -i tu-archivo.pem ubuntu@tu-ip-ec2

# Una vez dentro, verifica
cat ~/.ssh/authorized_keys
# Debe contener la parte pública de tu clave
```

### Error: "Connection timed out"

**Causa:** La instancia EC2 no es accesible

**Solución:**
1. Verifica que la instancia esté **running**
2. Verifica el Security Group permita SSH (puerto 22) desde 0.0.0.0/0 o desde la IP de GitHub Actions
3. Verifica que `EC2_HOST` sea la IP correcta

---

## ✅ Verificar que Funcionó

Después de aplicar el fix, cuando el workflow se ejecute, deberías ver:

```
✅ Run Deploy to EC2
Creating private key file...
✅ Private key created successfully
✅ Connecting to EC2...
✅ Directory created
✅ Files copied
✅ Service started
```

En lugar de:

```
❌ Load key "private_key.pem": error in libcrypto
❌ Permission denied (publickey).
```

---

## 📞 Si el Problema Persiste

### Opción 1: Generar Nueva Clave

En AWS Console:
1. EC2 → Key Pairs
2. Click "Create key pair"
3. Tipo: RSA
4. Formato: .pem
5. Descarga el archivo
6. Asocia la nueva clave a tu instancia

### Opción 2: Deployment Manual

Como alternativa temporal, puedes desplegar manualmente:

```bash
# Compilar localmente
./gradlew build

# Copiar a EC2
scp -i tu-archivo.pem build/libs/*.jar ubuntu@tu-ip-ec2:~/barbershop-api/
scp -i tu-archivo.pem scripts/*.sh ubuntu@tu-ip-ec2:~/barbershop-api/

# Conectar y ejecutar
ssh -i tu-archivo.pem ubuntu@tu-ip-ec2
cd ~/barbershop-api
./start-service.sh
```

### Opción 3: Contacto AWS Support

Si nada funciona, puede ser un problema con tu instancia EC2 o configuración de AWS.

---

## 📚 Referencias

- [GitHub Actions: Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [SSH Permission denied (publickey)](https://docs.github.com/en/authentication/troubleshooting-ssh/error-permission-denied-publickey)
- [AWS EC2 Key Pairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

---

**Última actualización:** 2025-12-09  
**Versión del Fix:** 2.0

