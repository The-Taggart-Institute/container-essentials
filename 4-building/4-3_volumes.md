# 4-3: Volumes

We're getting pretty handy with creating containers at this point. We can even make our own images to launch them from—images which include our own application code. The DevOps dream is tantalizingly close. One layer we haven't discussed much though? Data. 

Yes, that pesky little persistence layer that flies in the face of our ephemeral desires. If all our application code is in sacrificial containers, where is our data supposed to live?

We've kiiinda already seen the answer—or at least one really good one: Docker volumes. You know, those things we've been creating with `-v` when we add directories or files from our host filesystem into the container? Well it turns out there's another way to handle persistent data.

```bash
docker volume ls
```

What have we here? Docker volumes are managed storage locations we can attach to containers. They are considered the _preferred_ method of adding persistence to a containerized application.

## Creating a Volume

I don't create volumes manually very often. Instead, they're created as part of the Docker Compose workflow—but we'll get there. Let's go slow and learn how volumes work by making one manually now.

```bash
docker volume create myvol
docker volume ls
```

That `ls` doesn't tell us much, does it? Luckily, volumes also have an `inspect` command. Let's give it a shot.

```bash
docker volume inspect myvol
```

That's better. We see a bit of JSON that looks like:

```json
[
  {
    "CreatedAt": "2023-12-22T07:47:00Z",
    "Driver": "local",
    "Labels": null,
    "Mountpoint": "/var/lib/docker/volumes/myvol/_data",
    "Name": "myvol",
    "Options": null,
    "Scope": "local"
  }
]
```

Most of these fields are self-explanatory, but do notice the `Driver`. Turns out there are multiple driver options, as we'll see later. Drivers are how we can use cloud storage and other options for Docker volumes.

We also see the `Mountpoint`. That location is on your host right now! It's empty, but it's there. 

## Mounting a Volume

Time to start a container with the volume attached so we can add some data!

```bash
docker container run -it --rm -v myvol:/myvol ubuntu:latest
```

We're using Ubuntu mainly for the comfort of Bash. Notice the `-v` option. We're mounting the `myvol` volume to the path `/myvol` in the container.

> There are two syntaxes for mounting volumes: `-v` and `--mount`. We'll be using `-v` here for simplicity, but go [read the docs](https://docs.docker.com/storage/volumes/#choose-the--v-or---mount-flag) about the differences.

Once in the container, running `ls` confirms there's a `myvol` directory at the root of the filesystem. Let's add some data.

```bash
echo "I'm from a container!" > myvol/foo.txt
```

Then `exit` out of the container. If everything worked, we should have a file at `/var/lib/docker/volumes/myvol/_data/foo.txt`. You can check with `sudo cat`.

```bash
sudo cat /var/lib/docker/volumes/myvol/_data/foo.txt
```

And there it is: persistence beyond the life of a container.

Although this seems identical to the mounting we were doing prior, allowing Docker to manage the storage location has some performance benefits. Also, when we move beyond the `local` driver, the differences fade away.

Let's run another container, but this time use the mount options to make our volume read-only:

```bash
docker container run -it --rm -v myvol:/myvol:ro ubuntu:latest
```

See that `:ro` at the end there? It makes all the difference. Try adding content to `/myvol` now.

Mounting volumes read-only when we don't need write is a best practice, and a habit to get into. [Other options](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/storage_administration_guide/sect-using_the_mount_command-mounting-options#tabl-Using_the_mount_Command-Options) like `noexec` are worth considering as well.

That concludes our introduction to volumes. In practice, we don't really create them manually like this, but it's important to know how they function. The same is true for our next topic: networks.

## Check For Understanding

1. **What is the difference between a bind mount and a managed volume? When would you use each?**

2. **Think about backup strategies. How might you ensure that the data from a Docker volume is preserved?**
