TAG_NAME := aws-ami-php7
TAG_VERSION := php74

build-container:
	docker build --tag ${TAG_NAME} .

push-container: build-container
	docker login
	docker tag ${TAG_NAME} charly010/${TAG_NAME}:${TAG_VERSION}
	docker push charly010/${TAG_NAME}

run-container: build-container
	docker run -i -t aws-ami-php7 /bin/bash