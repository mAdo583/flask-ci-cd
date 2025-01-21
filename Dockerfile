# Use a Python base image (official Python image from Docker Hub)
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Upgrade pip and install dependencies
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Expose port 5000, the port your Flask app will run on
EXPOSE 5000

# Set the default command to run the Flask app
CMD ["python", "app.py"]

