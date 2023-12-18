# 4-1: Dockerfiles

In the last chapter, we used a Dockerfile to build an image for Impacket tools. That was cool, but wouldn't it be _even cooler_ if we could write our own Dockerfiles to make our images?

That's what we're doing now.

## Read the Docs!

I'm going to tell you up front that we will _not_ be covering every single instruction you can use in a Dockerfile. I strongly recommend you review the [Dockerfile reference](https://docs.docker.com/engine/reference/builder/) and keep it handy as you go through this chapter—and anytime you're creating a Dockerfile, really.

## What Is a Dockerfile?

From one point of view, a Dockerfile is a program. It's a set of instructions to Docker that tells it how to build an image. Simple enough, right?

Let's complicate it.

From _another_ point of view, a Dockerfile is a list of changes, which become layers atop the base image. A really cool way to see this is `docker image history`. Check out the history for one of our Python images. 

![4-1_history](../img/4-1_history.png)

What you're seeing, in reverse chronological order, is every instruction that went into the Dockerfile to make the image. That's why the "first" one is the `CMD` instruction, which determines the default command to execute when the image is run as a container.

## Writing the Dockerfile

But we're getting ahead of ourselves. We're going to make a new image from a Dockerfile, so let's get get up. Start by making a new folder called `mynodeapp`, and moving into it.

```bash
mkdir mynodeapp
cd mynodeapp
```

As the name might suggest, we're going to be making a tiny NodeJS application. But don't worry, you don't need to know _any_ JavaScript to make this happen. That part we'll handle for you. Download [mynodeapp.zip](./mynodeapp.zip) and extract its contents to your `mynodeapp` folder. You should now have a `src` folder that contains all the application code you'll need. No fuss, no muss.

Using any text editor you like, create a new file called, originally, `Dockerfile`. It's actually a "magic name" that Docker expects for certain operations. 

The first line of our Dockerfile is the `FROM` command. This defines the base image on which we'll build. So yeah, it's not _entirely_ from scratch, but base images are reasonable starting points.

The [Node Image Page](https://hub.docker.com/_/node/tags) shows a ton of tags to choose from. I like to use the latest version with an Alpine flavor. As of this writing, that means the `20-alpine` tag. So our instruction is:

```Dockerfile
FROM node:20-alpine
```

Don't worry that we haven't pulled the image yet; Docker knows what it needs to do during build. We'll get there.





