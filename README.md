# UFPS Mock API

Réplica simulada de la **API SAT-SIA / Divisist** de la UFPS, con datos de prueba. Permite desarrollar y desplegar el [backend de TuCarnet](../tucarnet_be) sin acceso a las APIs institucionales reales.

> ⚠️ **Solo para desarrollo y demos.** Devuelve datos ficticios definidos en `data.py`. No debe usarse como fuente de datos en un entorno oficial.

## Tecnologías

- **FastAPI** + **Uvicorn**
- **Pydantic**
- **Docker**

## Datos simulados

Los datos viven en `data.py`: estudiantes, profesores, directivos y cursos. Para añadir o editar registros, modifica los diccionarios de ese archivo (por ejemplo `ESTUDIANTES`).

## Ejecución local

### Con Docker (recomendado)

```bash
docker compose up
```

Queda disponible en `http://localhost:8000`.

### Con Python

```bash
python -m venv venv
source venv/bin/activate        # En Windows: .\venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn api_simulada:app --host 0.0.0.0 --port 8000 --reload
```

### Verificación

- Documentación interactiva (Swagger): `http://localhost:8000/docs`
- Health check: `http://localhost:8000/`
- Prueba de estudiante:
  ```bash
  curl http://localhost:8000/student/email/omardavidjm@ufps.edu.co
  ```
  Respuesta esperada: `{"ok": true, "data": {...}, "msg": "Estudiante obtenido con éxito"}`

## Formato de respuesta

Todas las respuestas siguen la estructura estándar del proyecto:

```json
{
  "ok": true,
  "data": { },
  "msg": "Mensaje descriptivo"
}
```

## Endpoints

### Health
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/` | Health check |
| GET | `/test-connection` | Test de conexión |

### Estudiante
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/student/email/{email}` | Estudiante por email **(usado por el backend de TuCarnet)** |
| GET | `/student/code/{code}` | Estudiante por código |
| GET | `/student/courses/{code}` | Cursos del estudiante |
| GET | `/student/courses/ac012/{code}` | Cursos AC012 del estudiante |
| GET | `/student/total_estudiantes/ac012` | Total de estudiantes AC012 |
| GET | `/student/courses/students/ac012` | Estudiantes por curso AC012 |

### Profesor
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/teacher/code/{code}` | Profesor por código |
| GET | `/teacher/courses/{code}` | Cursos del profesor |
| GET | `/teacher/students-course/{code}/{group}` | Estudiantes de un curso/grupo |
| GET | `/teacher/students-ac012/{code}/{group}` | Estudiantes AC012 de un curso/grupo |

### Directivo
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/boss/courses/{semester}/{program}` | Cursos por semestre y programa |
| GET | `/boss/courses/groups/{program}/{course}` | Grupos de un curso |
| GET | `/boss/courses/group/{program}/{course}/{group}` | Detalle de un grupo |
| GET | `/boss/semesters/{program}` | Semestres de un programa |

## Variables de entorno

| Variable | Descripción | Default |
|---|---|---|
| `PORT` | Puerto en el que escucha la app | `8000` |

El `Dockerfile` respeta `$PORT` (`--port ${PORT:-8000}`), por lo que funciona tanto en local como en plataformas que asignan el puerto dinámicamente (Railway, etc.).

## Despliegue en Railway

1. Crea un servicio conectado a este repositorio (Railway detecta el `Dockerfile`).
2. Añade la variable `PORT=8000`.
3. Genera el dominio enrutando al puerto **8000**.
4. Verifica con `https://<tu-dominio>/student/email/omardavidjm@ufps.edu.co`.

Luego, en el backend de TuCarnet, apunta `DIVISIST_API_URL` (y `MOODLE_API_URL`) a la URL pública de este mock.
