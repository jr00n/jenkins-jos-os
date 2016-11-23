build:
	docker build -t "jos/jenkins-jos-slave-maven3-ibmjdk8" -f Dockerfile .

.PHONY:test
test:
	docker build -t "jos/jenkins-jos-slave-maven3-ibmjdk8-candidate" -f Dockerfile .
	sh test/run
