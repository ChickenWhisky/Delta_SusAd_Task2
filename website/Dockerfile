FROM python:3.9-slim

# Set the working directory in the container
COPY . /website
WORKDIR /website

# Install the Python dependencies
RUN pip install --no-cache-dir psycopg2-binary Flask

# Copy the Flask app code into the container
COPY . .

EXPOSE 5000

ENV FLASK_APP=website.py
ENV FLASK_RUN_HOST=0.0.0.0

# Start the Flask app when the container launches
CMD ["flask", "run", "--host=0.0.0.0"]