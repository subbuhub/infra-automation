# Pre-requisites:

Install docker by following steps in the below given URL:

```shell script
https://docs.docker.com/engine/install/centos/
```

Check docker version

```shell script
docker --version
```

Check if docker is running or not 

```shell script
docker info
```


# Build docker image:

Note: Run all the below given commands from "app" folder

```shell script
cd app
docker build -t csmanyam/nodejs:web-app-1.0.0 .
```


# Push docker image to registry:

Note: Login to docker registry then run below given command to push image.

```shell script
docker push csmanyam/nodejs:web-app-1.0.0
```

# Run docker image :

```shell script
docker run -d -p 8080:8080 csmanyam/nodejs:web-app-1.0.0
```

Testing: Open http://localhost:8080 URL in web browser 

