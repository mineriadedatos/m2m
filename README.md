# 🚀 Entorno M2M (del aprendizaje **Manual** al **Automático**) con Docker

**Jupyter Notebook/Lab** es todo lo que necesitas.  
Lleva tus proyectos de *machine learning* a otro nivel y, cuando quieras, habilita **R**, **Java** o **C++** desde el `Dockerfile` (bloques opcionales, listos para descomentar).

---

## ✨ Características
- Jupyter **Notebook/Lab** en Docker.
- Exportación a **PDF Web** (Mermaid + LaTeX tal como se ve) con `nbconvert --to webpdf`.
- Soporte **opcional** de kernels: **R (IRkernel)**, **Java (IJava)** y **C++ (xeus-cling)**.
- Imagen basada en `continuumio/anaconda3` + `requirements.txt` del proyecto.

---

## 🔧 Requisitos
- Docker y Docker Compose (v2+).

---

## 🏁 Inicio rápido

### 1) Clonar, construir y levantar
```bash
git clone https://github.com/mineriadedatos/m2m.git
```

```bash
cd m2m
docker compose up --build
```

### 2) Abrir Jupyter
- Notebook: http://localhost:3131  
  (El token aparece en los logs: `docker logs -f ml`)
- Lab (opcional): http://localhost:3131/lab


> Si mapeaste otro puerto, ajusta la URL.

---

## 🧾 Exportar a PDF (con Mermaid + LaTeX)
```bash
# Dentro del contenedor o Terminal de Jupyter
jupyter nbconvert --to webpdf /opt/notebooks/RUTA/TuNotebook.ipynb
```

> Usa **WebPDF** (Chromium headless). Para PDF vía LaTeX puro (`--to pdf`), Mermaid no se renderiza (convierte los diagramas a imagen previamente).

---

## 🧪 Habilitar kernels opcionales (R, Java, C++)
Edita el `Dockerfile` y **descomenta** el bloque que necesites, luego reconstruye.

```dockerfile
# R + IRkernel
# RUN conda install -y -c conda-forge r-base r-irkernel && \
#     R -e "IRkernel::installspec(user = FALSE)"

# Java + IJava
# RUN conda install -y -c conda-forge openjdk=17 && \
#     pip install --no-cache-dir ijava && \
#     python -m ijava install --sys-prefix

# C++ (xeus-cling)
# RUN conda install -y -c conda-forge xeus-cling && \
#     jupyter kernelspec list
```

Reconstruir y levantar:
```bash
docker compose build --no-cache
docker compose up -d
```

---

## 🔒 Seguridad recomendada
- Mantén el **token** de Jupyter (no lo desactives).
- Si expones a Internet, limita el acceso por firewall a IPs confiables o pon un *reverse proxy* con HTTPS.
- Para uso local solamente, puedes ligar el puerto a `127.0.0.1`.

---

## 📦 `Dockerfile` (ejemplo)
```bash
FROM continuumio/anaconda3

ADD requirements.txt /
RUN pip install -r requirements.txt
EXPOSE 3130
CMD ["jupyter", "notebook", "--notebook-dir=/opt/notebooks", "--ip=0.0.0.0", "--port=3130", "--no-browser", "--allow-root"]

```

## 📦 `docker-compose.yml` (ejemplo)
```bash
version: "3.9"

services:
  anaconda:
    container_name: m2m
    build: .
    tty: true
    restart: unless-stopped # no reinicies si el contenedor fue detenido manualmente
    volumes:
      - ./notebooks:/opt/notebooks:rw   # tus .ipynb quedan fuera del contenedor
    ports:
      - "3131:3131" # puedes cambiara por - "3132:3131"

```

> El contenedor expone `3131`; cámbialo si ya está en uso.

---

## 📁 Estructura mínima
```
.
├─ notebooks/                # tus .ipynb
├─ requirements.txt
├─ Dockerfile
└─ docker-compose.yml
```

Listo. ¡A construir y automatizar! 🧠⚙️




### 🐳 Explora Docker
En otra terminal puede ver que el servicio  ya corre
```bash
docker ps
```
Salida:
```bash
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                    NAMES
15f94d9a7373   m2m-anaconda   "jupyter notebook --…"   21 seconds ago   Up 18 seconds   0.0.0.0:3131->3131/tcp   m2m

```

(opcional) si deseas ingresar dentro del contenedor

```bash
docker exec -it m2m bash
```
Salida:
```bash
(base) root@845d4d868b87:/#   
```



### License

GNU, see [LICENSE](LICENSE).

Grupo de Investigación en Ciencia de Datos e Inteligencia Artificial:
- sullondev@gmail.com


### Otros apuntes

Para decargar sólo la carpeta 252md del server público 191.98.175.170
```bash
scp -r asullom@191.98.175.170:/home/asullom/m2m/notebooks/252md C:\252md
```
