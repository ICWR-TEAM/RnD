# Docker

Written By Afrizal F.A

## Create Dockerfile Basic

```bash
mkdir sshserver
cd sshserver
nano Dockerfile
```

![1722762225174](image/Docker/1722762225174.png)

Dockerfile

```plaintext
FROM ubuntu:latest

# Instalasi OpenSSH server
RUN apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd

# Change 'password' for your password
RUN echo 'root:password' | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed -i 's/#GatewayPorts no/GatewayPorts yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
```

![1722762255763](image/Docker/1722762255763.png)

Build, Enter directory docker

```bash
# docker build -t <image_name> .
docker build -t sshserver .
```

![1722762400481](image/Docker/1722762400481.png)

Change image_name you will

## Create Docker Repository

![1722759114705](image/Docker/1722759114705.png)

Next

![1722759150032](image/Docker/1722759150032.png)

Push Docker

```bash
docker login

# docker tag <your_image>:<your_tag> <your_username>/<your_repository>:<your_tag>
docker tag sshserver:latest afrzlfa/sshserver:latest

# docker push <your_username>/<your_repository>:<your_tag>
docker push afrzlfa/sshserver:latest
```

![1722762525103](image/Docker/1722762525103.png)

Pull Docker

```bash
# If already exist
# docker rmi afrzlfa/sshserver:latest
docker login
# docker pull <your_username>/<your_repository>:<your_tag>
docker pull afrzlfa/sshserver:latest
```

![1722762781725](image/Docker/1722762781725.png)

Docker Run

```
# docker run -d -p <docker_host>:<docker_port> --name <container_name> -v <volume_host>:<directory_docker> --memory="<RAM, Example 512m>" --cpus="<CPU Core, Example: 1.0>" <image_name>

docker run -d -p 222:22 -p 8080:80 --name sshcontainer -v /tmp/:/mnt/ --memory="512m" --cpus="1.0" sshserver
# If already in use
# docker remove sshcontainer
```

![1722762829341](image/Docker/1722762829341.png)

Check Docker

```bash
docker ps
```

![1722762899067](image/Docker/1722762899067.png)

Login to container ssh

```bash
ssh root@<ip> -p 222
```

Running Pyhton Server

```bash
python3 -m http.server 80
```

![1722763360732](image/Docker/1722763360732.png)

Open Browser http://203.194.113.245:8080

![1722763428341](image/Docker/1722763428341.png)

## Create Docker DCT

```bash
mkdir ssh-dct
cd ssh-dct
nano Dockerfile
```

Dockerfile

```plaintext
FROM ubuntu:latest

# Instalasi OpenSSH server
RUN apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd

# Change 'password' for your password
RUN echo 'root:password' | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed -i 's/#GatewayPorts no/GatewayPorts yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

```

Create Docker Repository

![1722767346631](image/Docker/1722767346631.png)

Next

![1722767376617](image/Docker/1722767376617.png)

Docker Command

```bash
# docker trust key generate <your_username>
docker trust key generate afrzlfa
# docker trust signer add --key <your_username>.pub <your_username> <your_username>/<your_repository>:<your_tag>
docker trust signer add --key afrzlfa.pub afrzlfa afrzlfa/ssh-dct:latest
# docker trust key load <your_username>.pub --name <your_username>
# docker trust signer remove <your_username> <your_repository>
# docker trust inspect --pretty <your_repository>
docker trust inspect --pretty afrzlfa/ssh-dct:latest
```

![1722767684974](image/Docker/1722767684974.png)

Setting Environment Build

```bash
export DOCKER_CONTENT_TRUST=1
```

Build

```bash
# docker build -t <your_username>/<your_repository>:<your_tag> .
docker build -t afrzlfa/ssh-dct:latest .
```

![1722767727256](image/Docker/1722767727256.png)

Push docker

```bash
docker login

# docker tag <your_image>:<your_tag> <your_username>/<your_repository>:<your_tag>
docker tag afrzlfa/ssh-dct:latest afrzlfa/ssh-dct:latest

# docker push <your_username>/<your_repository>:<your_tag>
docker push afrzlfa/ssh-dct:latest

```

![1722767919962](image/Docker/1722767919962.png)

Pull Docker

```bash
# If images already exist
# docker images
# docker rmi <image_id_or_name>
# docker prune

docker login

# docker pull <your_username>/<your_repository>:<your_tag>
docker pull afrzlfa/ssh-dct:latest

```

Environment

```bash
# For Check Repository Key
# docker images
# docker trust inspect --pretty <your_repository>
export ENCODED_PASSPHRASE=$(cat ~/.docker/trust/private/<your_repository_key>.key | base64)
export DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE=$ENCODED_PASSPHRASE
```

![1722768074928](image/Docker/1722768074928.png)

Docker Push

```bash
docker login

# docker tag <your_image>:<your_tag> <your_username>/<your_repository>:<your_tag>
docker tag afrzlfa/ssh-dct:latest afrzlfa/ssh-dct:latest

# docker push <your_username>/<your_repository>:<your_tag>
docker push afrzlfa/ssh-dct:latest

```

![1722768168324](image/Docker/1722768168324.png)

Docker Pull

```bash
docker login
# docker pull <your_username>/<your_repository>:<your_tag>
docker pull afrzlfa/ssh-dct:latest
```

![1722768226328](image/Docker/1722768226328.png)

Docker Run

```
# docker run -d -p <docker_host>:<docker_port> --name <container_name> -v <volume_host>:<directory_docker> --memory="<RAM, Example 512m>" --cpus="<CPU Core, Example: 1.0>" <image_name>

docker run -d -p 222:22 -p 8080:80 --name sshdct -v /tmp/:/mnt/ --memory="512m" --cpus="1.0" afrzlfa/ssh-dct:latest
# If already in use
# docker remove sshdct
```

![1722768587778](image/Docker/1722768587778.png)

## Access Docker Shell

```bash
docker ps
# docker exec -it <container_id_or_name> /bin/bash
docker exec -it afrzlfa/dct-ssh:latest /bin/bash
# If success, enter to shell docker container
```

![1722768696659](image/Docker/1722768696659.png)
