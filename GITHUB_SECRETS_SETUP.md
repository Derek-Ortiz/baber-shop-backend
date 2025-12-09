# 🔐 Configuración de GitHub Secrets - Guía Rápida

## ¿Qué Secrets Necesito?

Necesitas configurar **3 secrets** en tu repositorio de GitHub para que el deployment automático funcione.

---

## 📝 Secret 1: `EC2_SSH_PRIVATE_KEY`

### ¿Qué es?
La clave privada SSH (archivo `.pem`) que usas para conectarte a tu instancia EC2.

### ¿Cómo obtenerla?

**En Windows:**
1. Abre el archivo `.pem` con Notepad
2. Copia TODO el contenido (incluyendo las líneas BEGIN y END)

**En Linux/Mac:**
```bash
cat tu-archivo.pem
```

### Formato del Secret:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAxxx...
(todo el contenido)
...xxxxx
-----END RSA PRIVATE KEY-----
```

### ⚠️ Importante:
- Copia TODO, incluyendo `-----BEGIN` y `-----END`
- NO agregues espacios extra
- NO compartas este secret

---

## 📝 Secret 2: `EC2_HOST`

### ¿Qué es?
La dirección IP pública o DNS de tu instancia EC2.

### ¿Cómo obtenerla?

1. Ve a la consola de AWS EC2
2. Selecciona tu instancia
3. Copia uno de estos valores:

**Opción 1 - IP Pública:**
```
18.234.123.456
```

**Opción 2 - DNS Público:**
```
ec2-18-234-123-456.compute-1.amazonaws.com
```

### Formato del Secret:
```
18.234.123.456
```
O
```
ec2-18-234-123-456.compute-1.amazonaws.com
```

---

## 📝 Secret 3: `EC2_USER`

### ¿Qué es?
El nombre de usuario SSH para conectarte a tu EC2.

### ¿Cuál usar?

**Para Ubuntu Server:**
```
ubuntu
```

**Para Amazon Linux:**
```
ec2-user
```

### Formato del Secret:
```
ubuntu
```

**Nota:** En tu caso, con Ubuntu Server, usa `ubuntu`

---

## 🎯 Resumen Visual

| Secret Name | Ejemplo de Valor | Dónde Encontrarlo |
|------------|------------------|-------------------|
| `EC2_SSH_PRIVATE_KEY` | `-----BEGIN RSA...-----END RSA...` | Archivo `.pem` de AWS |
| `EC2_HOST` | `18.234.123.456` | Consola AWS EC2 → Public IPv4 |
| `EC2_USER` | `ubuntu` | Según tu AMI (Ubuntu = ubuntu) |

---

## 📋 Pasos para Configurar en GitHub

### 1. Ve a tu repositorio en GitHub

### 2. Click en "Settings"

### 3. En el menú lateral:
```
Secrets and variables → Actions
```

### 4. Click en "New repository secret"

### 5. Para cada secret:

**Secret 1:**
- Name: `EC2_SSH_PRIVATE_KEY`
- Secret: Pega el contenido completo de tu archivo .pem
- Click "Add secret"

**Secret 2:**
- Name: `EC2_HOST`
- Secret: Pega la IP o DNS de tu EC2
- Click "Add secret"

**Secret 3:**
- Name: `EC2_USER`
- Secret: `ubuntu`
- Click "Add secret"

---

## ✅ Verificar Configuración

Una vez agregados los 3 secrets, deberías ver:

```
Repository secrets (3)

EC2_SSH_PRIVATE_KEY    Updated X minutes ago
EC2_HOST              Updated X minutes ago
EC2_USER              Updated X minutes ago
```

**⚠️ Nota:** No podrás ver el valor de los secrets después de crearlos (por seguridad). Si cometiste un error, elimínalo y créalo de nuevo.

---

## 🚀 Probar el Deployment

Una vez configurados los secrets:

```bash
git add .
git commit -m "Test deployment"
git push origin main
```

Ve a GitHub → Actions y observa el workflow ejecutándose.

---

## 🐛 Solución de Problemas

### Error: "Permission denied (publickey)"

**Causa:** La clave SSH es incorrecta

**Solución:**
1. Verifica que copiaste TODO el contenido del .pem
2. Incluye las líneas BEGIN y END
3. Elimina el secret y créalo de nuevo

### Error: "Host key verification failed"

**Causa:** Primera conexión SSH

**Solución:**
- El workflow maneja esto automáticamente con `-o StrictHostKeyChecking=no`
- Si persiste, verifica que el HOST sea correcto

### Error: "Connection timed out"

**Causa:** No se puede conectar a la EC2

**Solución:**
1. Verifica que la instancia EC2 esté corriendo
2. Verifica que el Security Group permita SSH (puerto 22)
3. Verifica que el `EC2_HOST` sea correcto

---

## 📞 ¿Necesitas Ayuda?

Consulta la guía completa: `DEPLOYMENT_GUIDE.md`

---

**Total de Secrets Necesarios:** 3  
**Tiempo de Configuración:** ~5 minutos  
**Versión:** 1.0.0

