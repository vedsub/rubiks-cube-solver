# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install system packages needed to compile the C code
# This is the crucial step for your .so file
RUN apt-get update && apt-get install -y make gcc

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your project files into the container at /app
COPY . .

# Run the makefile to compile the C code and create the libcubesolver.so file
RUN make

# Tell Render that the container listens on port 5000
EXPOSE 5000

# Define the command to run your app using Gunicorn
# This will be used by Render's "Start Command"
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]