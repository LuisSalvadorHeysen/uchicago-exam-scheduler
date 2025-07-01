FROM nginx:alpine

# Copy the static files to nginx
COPY index.html /usr/share/nginx/html/
COPY exams.json /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"] 