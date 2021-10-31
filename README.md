# Spring Boot Hyperledger Fabric Fullstack Blockchain Application running on Kubernetes
Blockchain Based Asset Transfer Application

Spring boot Hlf Starter is a library I wrote.It provides an easy way to get your Spring boot application using Hyperledger Fabric Gateway SDK v2.2 up and running quickly.

Spring boot Hlf Starter Project Link: [https://github.com/susimsek/spring-boot-hlf-starter](https://github.com/susimsek/spring-boot-hlf-starter)

I developed the backend of The Asset Transfer application using this library.
Asset Transfer Application is a blockchain based fullstack application.The chaincode part of the application is written in Go, the backend part is written in Spring boot, and the frontend part is written in Angular.

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/spring-boot-hlf-k8s-fullstack-blockchain-app.png" alt="Spring Boot Hyperledger Fabric Fullstack Blockchain Application running on Kubernetes" width="100%" height="100%"/>

# Application Introduction

The asset transfer application can be accessed from this link.  
http://hlf-k8.tk

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/frontend1.png" alt="Fullstack Blockchain Application Introduction 1" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/frontend2.png" alt="Fullstack Blockchain Application Introduction 2" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/frontend3.png" alt="Fullstack Blockchain Application Introduction 3" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/frontend4.png" alt="Fullstack Blockchain Application Introduction 4" width="100%" height="100%"/>

# Swagger Introduction

The swagger ui can be accessed from this link.  
http://api.hlf-k8.tk/swagger-ui.html

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/backend1.png" alt="Fullstack Blockchain Application Swagger Introduction 1" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/backend2.png" alt="Fullstack Blockchain Application Swagger Introduction 2" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/backend3.png" alt="Fullstack Blockchain Application Swagger Introduction 3" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/backend4.png" alt="Fullstack Blockchain Application Swagger Introduction 4" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/backend5.png" alt="Fullstack Blockchain Application Swagger Introduction 5" width="100%" height="100%"/>

# Hyperledger Explorer Introduction

The hyperledger explorer dashboard can be accessed from this link.  
http://explorer.hlf-k8.tk

You can login to hyperledger explorer with these credentials.


| Username      | Password      | 
| ------------- |:-------------:| 
| admin         | adminpw       |

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/explorer1.png" alt="Fullstack Blockchain Application Hyperledger Explorer Introduction 1" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/explorer2.png" alt="Fullstack Blockchain Application Hyperledger Explorer Introduction 2" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/explorer3.png" alt="Fullstack Blockchain Application Hyperledger Explorer Introduction 3" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/explorer4.png" alt="Fullstack Blockchain Application Hyperledger Explorer Introduction 4" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/explorer5.png" alt="Fullstack Blockchain Application Hyperledger Explorer Introduction 5" width="100%" height="100%"/>

# Grafana Introduction

The grafana dashboard can be accessed from this link.  
http://grafana.hlf-k8.tk

You can login to grafana with these credentials.


| Username      | Password      | 
| ------------- |:-------------:| 
| admin         | adminpw       |


<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/grafana1.png" alt="Fullstack Blockchain Application Grafana Introduction 1" width="100%" height="100%"/>

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/grafana2.png" alt="Fullstack Blockchain Application Grafana Introduction 2" width="100%" height="100%"/>

## Prerequisites for Kubernetes Deployment

* Kubernetes 1.12+
* Nfs Server
* Ingress Controller

* Minimum 8 cpu
* Minimum 10 GB Ram

## Preparation for Kubernetes Deployment

Edit these files according to your nfs server configuration.

Replace 192.168.12.9 with your nfs server ip

Replace /srv/kubedata with your nfs sharing path  

Paths of the files to be edited
```sh
deploy/k8s/pv/fabricfiles-pv.yaml
deploy/k8s/pv/kafka-pv.yaml
deploy/k8s/pv/zookeeper-pv.yaml
deploy/setup/copy_fabricfiles.sh
deploy/setup/create_fabric_dir.sh
```

Copy deploy folder to your nfs server.

Go the path of deploy folder,run these scripts on your nfs server.

```sh
cd deploy/setup/nfs-server-setup
```

```sh
sudo chmod u+x *.sh
```

```sh
./create_fabric_dir.sh
```

```sh
./copy_fabricfiles.sh
```

## Installation for Kubernetes Deployment

```sh
cd deploy/k8s
```

```sh
sudo chmod u+x *.sh
```

```sh
./install.sh
```

## Installation Using Vagrant for Kubernetes Deployment

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/vagrant-k8s-installation.png" alt="Fullstack Blockchain Application Vagrant Installation" width="100%" height="100%"/> 

### Prerequisites for Kubernetes Deployment

* Vagrant 2.2+
* Virtualbox or Hyperv
* Minimum 8 cpu
* Minimum 10 GB Ram

### Virtual Machine Setup

```sh
cd deploy
```

```sh
vagrant up
```

### Nfs Server Installation

```sh
vagrant ssh nfsserver
```

```sh
cd /vagrant/setup/nfs-server-setup
```

```sh
sudo chmod u+x *.sh
```

```sh
sudo ./install_nfs.sh
```

```sh
./create_fabric_dir.sh
```

```sh
./copy_fabricfiles.sh
```

```sh
exit
```

### Haproxy Installation

```sh
vagrant ssh haproxy
```

```sh
cd /vagrant/setup/haproxy-setup
```

```sh
sudo chmod u+x *.sh
```

```sh
sudo ./install-prereqs.sh
```

```sh
exit
```

### Kubernetes Installation

```sh
vagrant ssh k8smaster
```

```sh
 cd /vagrant/setup/kubernetes-setup
```

```sh
sudo chmod u+x *.sh
```

```sh
./install-prereqs.sh
```


### Application Installation

```sh
cd /vagrant/k8s
```

```sh
sudo chmod u+x *.sh
```

```sh
./install.sh
```

## Used Technologies 

<img src="https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app/blob/main/images/used-technologies.png" alt="Fullstack Blockchain Application Used Technologies" width="100%" height="100%"/>

* Go 1.14.6
* Spring Boot 2.5.5
* Angular 8.2.14
* Kafka
* Hyperledger Fabric 2.3
* Couchdb
* Hyperledger Explorer 1.1.8
* Swagger
* Docker
* Kubernetes
* Vagrant

## Contact

Şuayb Şimşek - [@linkledin](https://www.linkedin.com/in/şuayb-şimşek-29b077178) - suaybsimsek58@gmail.com

Project Link: [https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app](https://github.com/susimsek/spring-boot-hlf-k8s-fullstack-blockchain-app)
