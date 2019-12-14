.PHONY: all
all: docker release

docker:
	docker build -t go-check-plugins:${VERSION} .
	docker run -d --name=go-check-plugins go-check-plugins:${VERSION}
	docker cp go-check-plugins:/usr/local/bin ./bin
	docker stop go-check-plugins
	docker rm go-check-plugins
	docker rmi --force go-check-plugins:${VERSION}

release:
	tar czf /tmp/go-check-plugins_${VERSION}_linux_amd64.tar.gz bin/
	sum=$$(sha512sum /tmp/go-check-plugins_${VERSION}_linux_amd64.tar.gz | cut -d ' ' -f 1); \
	f=$$(basename go-check-plugins_${VERSION}_linux_amd64.tar.gz); \
	echo $$sum $${f} > /tmp/go-check-plugins_${VERSION}_sha512_checksums.txt; \
	echo $$sum;

clean:
	rm -rf ./bin
	docker rm -fv go-check-plugins
	docker rmi --force go-check-plugins:${VERSION}
