# 7-2: Kubernetes

It's pronounced "KOO-ber-net-eez." Just so we have that out of the way.

Hang around the container conversation—or really, any tech social media—for long enough, and you're bound to start hearing about [Kubernetes](https://kubernetes.io), sometimes abbreviated to K8s. But unless you're in this space, it can be a little tricky to understand what it does, or why it seems like everyone is talking about it. 

Kubernetes is an open source tool for **container orchestration**. In that way, it is similar to Docker Swarm, but K8s goes a fair ways beyond Swarm in terms of capability (and complexity).

Generally speaking, K8s is designed to deploy, update, rollback, and scale multi-container applications. It does this complete with load balancing, failure recovery, cloud native storage handling, and more. It's...a lot. But its power can't be ignored.

And, for what its worth, Kubernetes engineers are in high demand. As are security professionals who actually understand how containers and K8s work. Amazing hackers like [Ian Coldwater](https://hachyderm.io/@ian) have carved out quite a niche by specializing in this field. 

## Learning K8s

Knowing that Kubernetes exists and what it does is essential, but _using_ K8s is not. Consequently, we will not be deploying Minikube here or performing any of the other myriad learning activities available for this tool. I do however want to point you in the right direction, should you choose to explore K8s.

Unsurprisingly, the best place to start is on K8s's [own documentation](https://kubernetes.io/docs/concepts/). I'd review the Concepts first, then head _back_ to [Getting Started](https://kubernetes.io/docs/setup/) to walk through the creation of the learning environment. It is possible to use your VMs that you set up for this course to explore K8s—`minikube` specifically.


## "Do I Need Kubernetes?"

The answer to this question is almost always "No." As the documentation advertises, K8s is for "planet scale." You are not Google. You are not Microsoft. You're not even Twilio. Your little web app with a database layer and an API can do just fine without the technical debt of Kubernetes.

All too often, new developers believe they need to build their application with the idea that it must be ready for Google-scale from day 1. That simply isn't the case, and often introduces more complexity—that is, points of failure—to the system. Even with containers, the advice to start with the simplest working version and increase complexity as needed remains true.

So you start with Docker on a single host. Or Podman. You deploy a single app, maybe with Docker Compose. Then you discover the need for multiple services, replicated across regions. Time for Docker Swarm. And then, finally, you find the need for robust load balancing, updating, and more. That's when it's time to explore Kubernetes.

Unless you're just endlessly curious, in which case: have fun!

That, my friends, is it. We've reached the end of the instructional material for this course. All that remains is to discuss your Exhibition of Mastery. Well done making it this far!

