build:
	s2i build jenkins-master/. openshift/jenkins-2-centos7:latest myjenkins

.PHONY:test
test:
	s2i build jenkins-master/. openshift/jenkins-2-centos7:latest myjenkins
