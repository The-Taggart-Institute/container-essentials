# 7-1: Podman


Many chapters ago now, we mentioned that Docker was just one
implementations of an [open standard](https://opencontainers.org). But if you don't really have options when it comes to container runtimes, who cares who open the standard is?

Suppose that, for whatever reason, you wanted to use a container runtime besides Docker. You still wanted to deploy containers, but Docker's way of doing things wasn't to your liking. What could you do about that?

But good news fam: you _do_ have options. There are several alternative container runtimes around. The one we'll focus on is [Podman](https://podman.io)

## What?!

Okay fair question. What are we dealing with here, and why should we care? Their own [documentation](https://docs.podman.io/en/latest/) explains it this way: 

> Podman is a daemonless, open source, Linux native tool designed to make it easy to find, run, build, share and deploy applications using Open Containers Initiative (OCI) Containers and Container Images. Podman provides a command line interface (CLI) familiar to anyone who has used the Docker Container Engine. Most users can simply alias Docker to Podman (`alias docker=podman`) without any problems. Similar to other common Container Engines (Docker, CRI-O, containerd), Podman relies on an OCI compliant Container Runtime (runc, crun, runv, etc) to interface with the operating system and create the running containers. This makes the running containers created by Podman nearly indistinguishable from those created by any other common container engine.

So basically, Podman seeks to be a drop-in alternative to Docker. Neat, right? But _whyyyyyy_ would you bother?

The primary advantages to Podman are the following:

1. Daemonless: no long-running service requiring root privileges and a potentially-compromisable socket giving up control of all your containers.

2. Easy rootless mode, because of the daemonless design.

3. It's not from the evil corporate Docker.

That last one isn't a technical advantage, and yet strangely the one I hear discussed most often. Go figure.

TL;DR: want containers without all the Docker overhead? Podman is your buddy. And the extra good news? Almost all of the commands are interchangeable. In fact, it's common practice, as that quote suggests, to alias `docker` to `podman` to avoid confusion.

Let's try it out! 

## Installing Podman

Installing Podman is shockingly simple.

```bash
sudo apt install -y podman
```

Yep, really.

## Using Podman

You already know how to use Podman because you know how to use Docker! We'll leave off the alias for now, but try this new runtime on for size.

```bash
podman image ls
```

Yep, seems to work—but this is a different collection of images from Docker's, so we won't see any of the ones we previously downloaded. Oh, and another catch: when we go to pull, we'll need the full URL to the image, including the repo. No defaulting to Docker Hub anymore. To pull Docker images then, we'll prepend the image name and tag with `docker.io`:

```bash
podman image pull docker.io/alpine:latest
```

Aaaand we're off to the races. The rest works as you'd expect.


## Podman Limitations

So what _can't_ this snappy little container runtime do? For one thing, Swarm mode. Say goodbye to your use of services, and there's no such thing as `podman stack`. There's a reason for that, but for now, Podman is best used on single hosts, and for development or small deployments.

Podman also can't really do Docker compose files. There is such a thing as [podman-compose](https://docs.podman.io/en/latest/markdown/podman-compose.1.html), but it's just a wrapper for the Docker implementation. Again, this is not really what Podman is for. It's meant for small container use cases, or in conjunction with some more powerful tools.

## Building Images

This isn't really a Podman thing specifically, but if we don't have Docker, how are we supposed to built images? Do we...use Dockerfiles?

You can! `podman image build` will accept Dockerfiles. But also, Podman plays well with [Buildah](https://github.com/containers/buildah), an alternative image builder that does not require Docker at all! We won't go into detail on Buildah, but it's a fascinating way of thinking about building images. In some ways, it's much less "magical" than Docker in how it approaches the build. Worth exploring, anyhow.

That about does it for Podman. It's entirely optional, but you should know there are alternatives to Docker, should you need/want them.

Almost done! In our next and final chapter of material, we'll talk about that many-headed beast lurking in all conversations about containers: Kubernetes.

## Check For Understanding

1. **Why is "daemonless" design considered more secure?**

2. **Use Podman to recreate some of our exercises in [4-3](../4-building/4-3_volumes.md) and [4-4](../4-building/4-4). Also try some secrets, like in [5-4](../5-swarm/5-4_secrets.md). What works? What doesn't? Does this seem like a viable replacement?**

