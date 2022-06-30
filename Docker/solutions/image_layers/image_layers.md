## Run, Forest, Run

### Objective

Learn what restart policies do and how to use them

### Instructions

1. Run a container with the following properties:

* image: alpine
* name: forest
* restart policy: always
* command to execute: sleep 15

`docker run --name=forest --restart=always alpine sleep 15`

1. Run `docker container ls` - Is the container running? What about after 15 seconds, is it still running? why?


2. How then can we stop the container from running?
3. Remove the container you've created

```
    docker ps
    docker 
                    ```
4. Run the same container again but this time with `sleep 600` and verify it runs
5. Restart the Docker service. Is the container still running? why?
6. Update the policy to `unless-stopped`
7. Stop the container
8.  Restart the Docker service. Is the container running? why?
