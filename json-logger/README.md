# random-json-logger

Docker image for a random json log generator, based on Alpine Linux.

## What is this?

This image will execute a container which will generate four random log messages:

* `{"@timestamp": "2018-03-02T22:33:27-06:00", "level":"ERROR", "message": "something happened in this execution."}`
* `{"@timestamp": "2018-03-02T22:33:27-06:00", "level":"INFO", "message": "takes the value and converts it to string."}`
* `{"@timestamp": "2018-03-02T22:33:27-06:00", "level":"WARN", "message": "variable not in use."}`
* `{"@timestamp": "2018-03-02T22:33:27-06:00", "level":"DEBUG", "message": "first loop completed."}`

## Why this Image?

I've had the necessity to create a random json logger to test log configurations with containers, this helped me out to do it easily.

## What is inside of this repo?

In this git repository you will find the docker image definitions for the random json Logger for Alpine Linux

* `Dockerfile` -> Contains image definition.
* `entrypoint.sh` -> Shell code to generate log messages.

## How do I use this image?

To use this image you must do as follows:

```bash
# you can use tags latest
docker pull sikwan/random-json-logger:latest

# to run the image just execute
docker run -d sikwan/random-json-logger:latest
```

You will have now a docker container running and generating json log messages, locate it running:

```bash
docker ps
```

You can see the logs using this command

```bash
docker logs <- container-id ->
```

## How do I build this images?

First things first, you can find these docker images in `sikwan/random-json-logger`
but you can also build a specific version on your own, you only need:

* docker
* git

Clone this repo

`git clone https://github.com/sikwan/random-json-logger.git`

Go to the folder in your terminal and type this:

```bash
# cd into folder
cd random-json-logger
# Then build the new image
docker build -f Dockerfile .
```

If you want to tag your image use the following command

```bash
docker build -f Dockerfile -t yourbase/yourname:version .
```

---
For more on docker build reference to the [Documentation](https://docs.docker.com/engine/reference/commandline/build/)

You can get the source from the image in the [Repository](https://github.com/sikwan/random-json-logger)