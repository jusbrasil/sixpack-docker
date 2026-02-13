FROM python:2.7.18

LABEL maintainer="Leonardo Gamas <leogamas@gmail.com>"

RUN python -m pip install --upgrade "pip<21"

# Sixpack 2.0.2 dependencies (pinned to versions that pip resolved to)
RUN pip install \
  hiredis==0.1.1 \
  redis==2.9.0 \
  mock==1.0.1 \
  Werkzeug==0.9.1 \
  PyYAML==3.10 \
  Flask==0.10 \
  Flask-SeaSurf==0.1.13 \
  Flask-Assets==0.8 \
  fakeredis==0.3.0 \
  decorator==3.3.2 \
  jsmin==2.0.2-1 \
  python-dateutil==1.5 \
  Markdown==2.4 \
  Flask-DebugToolbar==0.9.0 \
  closure==20121212

# Install sixpack without pulling yuicompressor from PyPI
RUN pip install --no-deps sixpack==2.0.2

RUN pip install gunicorn==19.3.0 gevent==1.0.1

CMD ["gunicorn", "--access-logfile", "-", "-w", "8", "-b", "0.0.0.0:8000", "--worker-class=gevent"]
