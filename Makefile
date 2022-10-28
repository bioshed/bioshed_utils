TAG=latest

all: build push

build:
	docker build -t $(NAME):$(TAG) -f $(NAME).Dockerfile ./
	docker tag $(NAME):$(TAG) $(REGISTRY):$(TAG)

push:
	docker push $(REGISTRY):$(TAG)
