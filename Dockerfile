FROM swiftlang/swift:nightly-6.0-focal

ENV APP_HOME ./app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
