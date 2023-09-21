# Grew match Daphne

## Description

A docker instance of [GrewMatch](https://match.grew.fr/), pre-configured to run with the Ancient Greek [Daphne](https://github.com/francescomambrini/Daphne) treebanks. It reproduces the instruction given [here](https://grew.fr/grew_match/install/)

## How to build it and run it

1. build:

Move to the directory where the `Dockerfile` is, then:

```bash
docker build -t grewmatch .
```

2. run:

```
docker run -it --rm -p 8000:8000 -p 8899:8899 grewmatch
```

Use `-d` if you want it in background!