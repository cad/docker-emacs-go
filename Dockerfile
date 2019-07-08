FROM golang:1.12.6-alpine3.10

MAINTAINER Cad <mustafa@arici.io>

RUN apk update && apk add ca-certificates bash git emacs

RUN echo 'export PATH="$PATH:/go/bin"' >> /etc/profile

# install go depencencies
ENV GO111MODULE on
RUN go get -u golang.org/x/tools/cmd/gopls@latest
RUN go get golang.org/x/tools/cmd/goimports@latest
RUN go get -u golang.org/x/tools/cmd/guru@latest

COPY emacs.el /root/.emacs
RUN emacs --batch -l /root/.emacs

VOLUME /workspace

WORKDIR /workspace

CMD ["emacs"]
