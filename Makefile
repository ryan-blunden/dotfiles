run:
	docker run -it --name yodaspeak-coder -v $PWD:/usr/src/app --platform linux/arm64 ryanblunden/yodaspeak-coder:latest bash

start:
	docker start -i yodaspeak-coder
