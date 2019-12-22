# Use an official Python runtime as a parent image
FROM python:3.7-slim-buster

# Set environment varibles
ENV PYTHONUNBUFFERED 1

RUN apt-get update; apt-get install -y build-essential zlib1g-dev libpq-dev libpng-dev libjpeg-dev libtiff-dev libwebp-dev libfreetype6-dev nginx
RUN rm /lib/systemd/system/nginx.service
COPY ./requirements.txt /code/requirements.txt
COPY ./dcms/requirements.txt /code/dcms-requirements.txt
RUN pip install --upgrade pip
# Install any needed packages specified in requirements.txt
RUN pip install -r /code/dcms-requirements.txt
RUN pip install -r /code/requirements.txt

# Copy the current directory contents into the container at /code/
COPY . /code/
COPY ./prod.env /code/.env
# Set the working directory to /code/
WORKDIR /code/

EXPOSE 8000
CMD exec /code/run.sh
# CMD exec gunicorn dcms.wsgi:application --bind 0.0.0.0:8000 --workers 3
