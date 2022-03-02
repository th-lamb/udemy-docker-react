# Multi-step process:
# 1. Build phase for our application
# 2. Run phase for nginx server


#----------------------------------------------------------
# "Build phase":
# - install dependencies, and
# - build our application.
#----------------------------------------------------------
FROM node:16-alpine as builder

# https://ausytechnologies.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/11437068#questions/14297316
USER node
RUN mkdir -p /home/node/app

WORKDIR /home/node/app

COPY package.json .
RUN npm install

COPY --chown=node:node ./ ./
RUN npm run build

# "Build phase" for our application finished. The folder 
# /home/node/app/build contains all the stuff we care about.


#----------------------------------------------------------
# "Run phase":
# - use the nginx image, and
# - copy over the result of the build phase (only what we need).
#----------------------------------------------------------

# https://hub.docker.com/_/nginx
# [...]
# Documentation for "Hosting some simple static content"
#   FROM nginx
#   COPY static-html-directory /usr/share/nginx/html
# [...]
FROM nginx
# Elastic Beanstalk will look for an EXPOSE instruction and map a port for incoming traffic.
EXPOSE 80
COPY --from=builder /home/node/app/build /usr/share/nginx/html
