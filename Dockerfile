FROM ibmcom/swift-ubuntu:latest

ENV APP_HOME ./app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
