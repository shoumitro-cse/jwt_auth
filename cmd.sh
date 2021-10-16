django-admin startproject jwt_auth
cd  jwt_auth
/home/shoumitro/.pyenv/versions/3.6.12/bin/python -m venv env
source ./env/bin/activate
python manage.py migrate
python manage.py startapp users
pip install django
pip install djangorestframework-simplejwt
python manage.py migrate
python manage.py runserver 127.0.0.1:7000

