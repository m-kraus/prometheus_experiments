TAG = 0.1.0
NAME = json_echo_server

REPO = krausm/$(NAME)
IMAGE=$(REPO):$(TAG)

.PHONY: echo build run run_shell

echo:
	echo $(IMAGE)

build:
	docker build -t $(IMAGE) .
	docker images | grep '$(REPO)'

push:
	docker push $(IMAGE)

run:
	-docker run -it --rm -p 5001:5001 --name $(NAME) $(IMAGE)

