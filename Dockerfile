FROM golang:1.13.5-alpine3.11

MAINTAINER Cad <mustafa@arici.io>

RUN apk update && apk add build-base ca-certificates bash git emacs openssh-client
RUN git config --global user.email "mustafa@arici.io" && git config --global user.name "Mustafa Arici"

RUN echo 'export PATH="$PATH:/go/bin"' >> /etc/profile

VOLUME /go/pkg/mod

# install go depencencies
ENV GO111MODULE on
RUN go get golang.org/x/tools/gopls@latest
RUN go get golang.org/x/tools/cmd/goimports@latest
RUN go get golang.org/x/tools/cmd/guru@latest

COPY emacs.el /root/.emacs
RUN emacs --batch -l /root/.emacs

VOLUME /workspace

WORKDIR /workspace

CMD ["emacs"]
