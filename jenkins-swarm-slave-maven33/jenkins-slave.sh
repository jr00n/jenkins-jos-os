#!/bin/bash

master_username=${JENKINS_USERNAME:-"admin"}
master_password=${JENKINS_PASSWORD:-"password"}
slave_executors=${EXECUTORS:-"1"}

#What is the OpenShift service name voor the master/slave communication
#JNLP_SERVICE_NAME is the enviroment variable specified in the DeploymentConfig
#if not specified "JENKINS_JNLP" will be used.
JNLP_SERVICE_NAME=${JNLP_SERVICE_NAME:-JENKINS_JNLP}
#convert to uppercase and replace '-' with '_'
JNLP_SERVICE_NAME=`echo ${JNLP_SERVICE_NAME} | tr '[a-z]' '[A-Z]' | tr '-' '_'`
T_HOST=${JNLP_SERVICE_NAME}_SERVICE_HOST
# the '!' handles env variable indirection so we can resolve the nested variable
# see: http://stackoverflow.com/a/14204692
JNLP_HOST=${!T_HOST}
T_PORT=${JNLP_SERVICE_NAME}_SERVICE_PORT
JNLP_PORT=${!T_PORT}

export JNLP_PORT=${JNLP_PORT:-50000}


echo "Running Jenkins Swarm Plugin...."

# jenkins swarm slave
JAR=`ls -1 /opt/jenkins-slave/bin/swarm-client-*.jar | tail -n 1`

if [[ "$@" != *"-master "* ]] && [ ! -z "$JENKINS_PORT_8080_TCP_ADDR" ]; then
	#PARAMS="-master http://${JENKINS_SERVICE_HOST}:${JENKINS_SERVICE_PORT}${JENKINS_CONTEXT_PATH} -tunnel ${JENKINS_SLAVE_SERVICE_HOST}:${JENKINS_SLAVE_SERVICE_PORT}${JENKINS_SLAVE_CONTEXT_PATH} -username ${master_username} -password ${master_password} -executors ${slave_executors}"
  PARAMS="-master http://${JENKINS_SERVICE_HOST}:${JENKINS_SERVICE_PORT} -tunnel ${JNLP_HOST}:${JNLP_PORT} -username ${master_username} -password ${master_password} -executors ${slave_executors}"
fi

echo Running java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
exec java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
