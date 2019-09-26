FROM python:3-alpine

MAINTAINER Michka Popoff <michkapopoff@gmial.com>

LABEL "com.github.actions.name"="Check status"
LABEL "com.github.actions.description"="Check the azure status after the checks pass"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="green"

COPY check.py /
ENTRYPOINT ["python3", "/check.py"]