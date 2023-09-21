FROM ocaml/opam:ubuntu-ocaml-4.14

# General container setup

# ENV TZ="Europe/Paris"
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone    

RUN sudo apt-get update \
	&& sudo apt-get install -y git \
	&& sudo apt-get install -y opam \
	&& sudo apt-get install -y make wget m4 unzip librsvg2-bin curl bubblewrap \
	&& sudo apt-get install -y pkg-config openssl libssl-dev \
	&& sudo apt-get install -y libpcre3-dev sqlite3 zlib1g-dev \
	&& sudo apt-get install -y libgmp3-dev libsqlite3-dev libgdbm-dev \
	&& sudo apt-get install -y libcairo-dev \
	&& sudo apt-get install -y graphviz ocamlbuild

RUN sudo apt-get clean && sudo apt-get autoremove

# Install the backend

RUN opam remote add grew "http://opam.grew.fr"
RUN opam install --yes ssl ocsipersist-dbm fileutils eliom
RUN opam instal --yes dep2pictlib grew

WORKDIR /home/opam

# Download the page

RUN git clone https://gitlab.inria.fr/grew/grew_match_back.git
RUN git clone https://gitlab.inria.fr/grew/grew_match.git

### Prepare the data

# 4.0 setup the corpus

RUN git clone https://github.com/francescomambrini/Daphne
RUN mkdir ./data \
	&& find ./Daphne -type f -name "*.conllu" -exec cp {} ./data \; && \
	rm -rf Daphne

# TEST: we put also a UD treebank for testing purposes...
# RUN git clone https://github.com/UniversalDependencies/UD_French-PUD.git /home/opam/data/UD_French-PUD/

# 4.1 describe the corpora

RUN mkdir ./corpora
COPY ./config/agreek.json /home/opam/corpora/agreek.json

# 4.2 interface description
COPY ./config/config.json /home/opam/grew_match/config.json

# 4.3 setup the config file `gmb.conf.in`
COPY ./config/gmb.conf.in__TEMPLATE /home/opam/grew_match_back/gmb.conf.in

# 4.4 Setup the config file Makefile.options
COPY ./config/Makefile.options__TEMPLATE /home/opam/grew_match_back/Makefile.options

# 5.0 compile the corpora and start the server
COPY --chown=opam:opam ./startscript.sh /home/opam/startscript.sh
RUN chmod 755 startscript.sh
ENV PATH=${PATH}:/home/opam/.opam/4.14/bin

WORKDIR /home/opam/grew_match
CMD ["/home/opam/startscript.sh"]