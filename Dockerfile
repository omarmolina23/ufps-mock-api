FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY api_simulada.py .
COPY data.py .

EXPOSE 8000

CMD uvicorn api_simulada:app --host 0.0.0.0 --port ${PORT:-8000}
