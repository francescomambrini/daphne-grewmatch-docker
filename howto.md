# How to dockerize

See [here](https://grew.fr/usage/docker/). This dockerfile combines both `grew`
and `dep2pict`.

[dep2pict](https://gitlab.inria.fr/dep2pict/dep2pict_doc/-/tree/master/content) is
used to visualize the results and convert them to pdf or svg.

## Dockerfile

```
FROM ocaml/opam:ubuntu

RUN sudo apt-get update \
		&& sudo apt-get upgrade --assume-yes \
		&& sudo apt-get install python3-pip pkg-config --assume-yes \
		&& sudo apt libcairo2-dev wget m4 unzip librsvg2-bin curl bubblewrap --assume-yes

RUN opam remote add grew "http://opam.grew.fr" \
		&& opam install --yes grew grewpy dep2pict \
		&& pip3 install grew

```

## Build the image

`docker build -t grew .`

## Run

`docker run -v $(PWD)/data:/home/opam/data -it grew bash`

## Run queries from command line

`grew grep -pattern <pattern_file> -i <corpus_file>`

## Run with simple visualization

`grew grep -pattern <pattern_file> -i <corpus_file> -html | python ~/bin/grew-docker/scripts/visualize_results.py`
