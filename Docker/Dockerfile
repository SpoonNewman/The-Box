FROM python:3

WORKDIR /usr/src/app

COPY ../ . 

WORKDIR /usr/src/app/App

RUN pip install --no-cache-dir -r requirements.txt

CMD ["flask", "run", "--app", "app.py"]