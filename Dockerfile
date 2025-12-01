FROM python:3.14-slim

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt

COPY app.py app.py

EXPOSE 5000

CMD [ "python", "app.py" ]