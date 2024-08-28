# Start with a base image containing Python runtime
FROM python:3.10

#change working directory
WORKDIR /app

ENV DEEPFACE_HOME=/root/df

# Install any needed packages specified in requirements.txt
# Install the required system packages, including libGL for OpenCV or other dependencies
# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0
RUN pip install deepface
RUN pip install tf-keras
RUN pip install fastapi
RUN pip install uvicorn

# Copy the current directory contents into the container at /app
COPY app.py /app

# COPY assets/images/ /app/

# COPY assets/models/vgg_face_weights.h5 /root/df/.deepface/weights/

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Run app.py when the container launches
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]