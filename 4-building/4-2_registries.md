# 4-2: Registries

"Daddy, where do images come from?"

"Well, when a developer loves a codebase very much..."

Just kidding. They come from **image registries**. These are web applications that publish repositories of images, submitted by authorized users of the registry.

The best known (and default for Docker) is [Docker Hub](https://hub.docker.com). This is where all the base images we've used so far have come from. But it is by no means the only registry out there. Here are a few others to know about.

## Quay 

[Quay](https://quay.io) is Red Hat's proprietary image repository, but many of the images hosted there can be used by the general public. [This Ubuntu image](https://quay.io/repository/bedrock/ubuntu), for example, works just fine. Try pulling it down.

```bash
docker image pull quay.io/bedrock/Ubuntu
```

Hey, look at that! Our image list now shows `quay.io/bedrock/ubuntu`, separately from the `ubuntu` image we pulled previously. And it works just like our others! Try it with `docker container run --rm -it quay.io/bedrock/ubuntu /bin/bash`.

Yep, just like usual. So what's up with Quay? Why did Red Hat make their own registry?

We'll discuss alternative container runtimes a little later in the course, but largely Quay supports Red Hat's own container-based products, including its enterprise container orchestration product, [OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift).

## GHCR

GitHub maintains its own container registry known as [GHCR](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry), or the GitHub Container Registry. 

Original, right?

Rather than presenting a specific web portal for the registry, GHCR works as part of GitHub itself, offering a deployment target for GitHub users as part of their project repositories. Published images are available at paths under `https://ghcr.io`.

But pulling images works the same way, once you have a path to a project's published image.

## Docker Hub

We've arrived at the big blue whale, the Ur-registry. [Docker Hub](https://hub.docker.com) was the first major registry around, and continues to be the most commonly used.

It's also the one that I'd recommend making a free account on. With an account, you are able to upload your own images.

Once you have an account, you can run:

```bash
docker login
```

to authenticate the CLI tool to the Docker Hub. You'll need your username and password.

> You can use `docker login` to auth to other registries as well! You just provide the server name/address after `docker login`.

## Host Your Own!

It turns out you can host your own image registry! As you might expect, everything you need exists as a [Docker image](https://hub.docker.com/_/registry). 

Let's try running our own registry and pushing the `mynodeapp` image to it.

Start by pulling down the registry image.

```bash
docker image pull registry:2
```

And now we'll run it. We'll run this one semi-permanently, using the `--restart` policy of `always` to keep it up and running. We'll forward port 5000 as well. 

```bash
docker container run -dp 5000:5000 --name registry --restart always registry:2 
```

Now, in order to "assign" an image to this new registry, we need to retag it so that its name matches the registry. That's why the image we downloaded from `quay.io` was tagged `quay.io/bedrock/ubuntu`. So for our local registry, the `mynodeapp` image needs to become `localhost:5000/mynodeapp`. We can use `docker image tag` to set this label.

```bash
docker image tag mynodeapp localhost:5000/mynodeapp
```

And now, we can publish our image to the new registry!

```bash
docker image push localhost:5000/mynodeapp
```

Once done, we can use the registry's [HTTP API](https://distribution.github.io/distribution/spec/api/) to prove we've published it.

```bash
curl localhost:5000/v2/_catalog
```

Hey look! There it is.

We can bring down the registry with `docker container stop registry`, unless you want to experiment further.

### Uh, Why Did We Just Do That?

Running your own image registry is not a required aspect of using containers, but many organizations choose to do so in order to securely distribute containers within their network, but many more simply rely on public registries, paying for accounts to host private images.

And that concludes our brief exploration of registries. I want you to understand the underpinnings of container infrastructure, even if you don't have to engage with it regularly. The registry system is one such topic.

## Check For Understanding

Push the `alpine` image to your local registry. Use `docker image tag` to push more than one version, then use the HTTP API to list all the versions hosted in your registry.

