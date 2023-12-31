#!/bin/bash

# start front-end in background

python3 -m http.server &

# copy config files from mounted volumes to the place where they are expected
# cp /data/config.json /home/grewmatch/grew_match/corpora/config.json
# cp /data/lang.json   /home/grewmatch/grew_match_back/corpora/lang.json

# compile treebank for use with grew
# this command writes data into into the volume /data which must be copied to the container
# necessary, because if the compiled data exists, no compilation is done, but the meta data will be read from /home/grewmatch/grew_match/meta
#grew compile -grew_match_server /home/grewmatch/grew_match/meta  -i /home/grewmatch/grew_match_back/corpora/lang.json

grew compile -grew_match_server /home/opam/grew_match/meta -i /home/opam/corpora/agreek.json

# go where the makefiles are
pushd /home/opam/grew_match_back

# run back-end
make test.opt