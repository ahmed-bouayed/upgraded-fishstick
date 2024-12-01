# Use the official Jekyll image from Docker Hub
FROM jekyll/jekyll:latest

# Set the working directory inside the container
WORKDIR /srv/jekyll

# Install required dependencies (if any)
#RUN apt-get update -y && apt-get install -y libpq-dev

# Install Bundler and any required Ruby dependencies
RUN gem install bundler

# Copy the current directory contents into the container at /srv/jekyll
COPY . .

# Install project dependencies via Bundler
RUN bundle install

# Expose port 4000 for the Jekyll server
EXPOSE 4000

# Run Jekyll and enable live-reload
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--watch"]
