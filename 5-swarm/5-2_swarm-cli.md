# 5-2: Swarm CLI

Swarm mode comes with some new CLI commands to create and interact with these new, multi-node structures. For this chapter, we'll focus on **services**. Services are sets of containers, one or more replicas, all running from the same image.

Replicas can be distributed amongst swarm nodes, so no one node has to do all the work of running a service. The manager, which is where we create the service, will handle the scheduling of containers on nodes based on availability.

Let's make one with the CLI and see how it works.

## Services

Just like before, we'll start with trusty ol' Nginx.

Unless otherwise specified, every command from here on out happens on the manager node.

```bash
docker service create --name web -p 80:80 nginx
```

![5-2_web](../img/5-2_web.png)

We'll get back messages that tell us that 1/1 containers are running and that the service is "converged," meaning all required updates have been made. Now of course if we `curl localhost`, we'll see the default Nginx page. 

`docker container ls` will show us one container licas

### Update

### Rollback
