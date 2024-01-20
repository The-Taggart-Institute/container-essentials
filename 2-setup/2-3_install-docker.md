# 2-3: Lab Setup - Install Docker

At long last, it's time to install Docker so we can get to the business of containers. 

## Easy Mode: The Script

Do you just want to get up and running with Docker? Great. Log into your manager VM, then run:

```bash
curl -L https://github.com/The-Taggart-Institute/container-essentials/raw/main/2-setup/install-docker.sh | bash
```

You'll need to enter your `sudo` password. Once it's finished, log out and back in. You should now be able to run `docker image ls` and see an empty list of images.

Now from the manager VM, SSH into the worker VM and repeat the installation process. 

Congratulations! Docker is installed.

## Normal Mode: Explaining the Script

If you care about _how_ the installation worked (and you should), this section is for you. Let's break it down piece by piece.


### Add Docker GPG Keys

We don't want to rely on the version of Docker offered by Ubuntu's own repositories; it's too old! Instead, we're going to use Docker's own repos. That requires us to save Docker's public signing key to verify the packages. The way we do that in Ubuntu has changed recently, moving away from `apt-key add` to manual installation in a location of our choosing. In this case, we're going to make a folder at `/etc/apt/keyrings` to save keys.

```bash
# Install Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
### Add Docker Repo

Now that we have the key, we need to use it in our definition of a new source. We represent that source with a file in `/etc/apt/sources.list.d`, the contents of which is a specially-formatted line defining the source as a `.deb` repo, signed by the key we just saved. We use some of our machine's own info to fill in the details.

```bash
echo \
	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
	sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
```
### Install

We then update our sources and install the list of packages needed to get up and running with Docker.

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### The `docker` Group

Finally, we add our user to the `docker` users group. This is a **Super Bad Idea™** in production, as we'll discuss later, but for now it means we don't need to use `sudo` for all our Docker commands.

```bash
sudo gpasswd -a $USER docker
```

Docker is now set up and ready to run! Time to learn about these "images" and "containers" we keep mentioning.

