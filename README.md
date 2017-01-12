docker-ciao
===========
[CIAO](https://github.com/01org/ciao) development environment  with Docker containers

## Main Features
- Easy to use
- Fast deployment with Docker containers
- Minimal configuration and dependencies
- Take full advantage of your dev box with containers (instead of VMs).
- CIAO installation from source code
- Always in the edge with `from master` source code
- Hack it in your local machine and test it in your containers.

## Initial Requirements
- go +1.7
- Docker
- docker-compose
- Common utils: ip, git, curl, unxz

## Setup your Golang environment
```bash
mkdir ~/go

# You could put it in your ~/.bashrc
export GOPATH=~/go

go get github.com/01org/ciao/...
```

Clone it
```bash
git clone https://github.com/obedmr/docker-ciao.git
cd docker-ciao
```

## Start your ciao development environment...!
```bash
./run.sh
```
You can also re-launch any container, this can be really useful in the case that you want re-start a single container.
- Example for ciao-controller re-launch

```bash
docker-compose kill ciao-controller
docker-compose up -d ciao-controller
```

## Starting Container in Prompt Mode (not starting the service)
if you want to run a container and get into prompt:
```bash
docker-compose kill ciao-controller
docker-compose run ciao-controller bash
```

## Checking Logs
```bash
docker-compose logs -f
```

## Getting inside CIAO containers
```bash
docker-compose exec ciao-<role> bash
```

CIAO CLI
--------
```bash
docker-compose exec ciao-controller bash
```

Then, inside the container
```
ciao-cli <your_option>
```

<WIP>CIAO webui
----------
You can access your Ciao Cluster webui at:
https://your-host.example.com

CIAO Development
----------------
Now, you can start hacking the CIAO repository you cloned at step ``Clone CIAO Project``

Once you make changes in code, you can:
```bash
docker-compose kill ciao-<role>
docker-compose up ciao-<role>
```
Behind the scenes, it will destroy the old container and will build a new one
with the updated source code.

## Questions?
```
obed.n.munoz@intel.com
```
