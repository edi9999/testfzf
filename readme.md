To run the tests, do :

```sh
docker build
docker run -i -t <idfrompreviouscommand> bash
# inside the docker instance :
mocha /src/test.js --reporter json-stream | fzf -1 --margin 5%,5%
```
