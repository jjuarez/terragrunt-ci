FROM alpine:3.8 as builder

ENV TERRAGRUNT_VERSION="0.17.4"
ENV MONGODB_ATLAS_VERSION="0.8.1"

RUN apk --no-cache add curl=7.61.1-r1 && \
    curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt
RUN curl -sL https://github.com/akshaykarle/terraform-provider-mongodbatlas/releases/download/v${MONGODB_ATLAS_VERSION}/terraform-provider-mongodbatlas_v${MONGODB_ATLAS_VERSION}_linux_amd64 -o /tmp/terraform-provider-mongodbatlas_v${MONGODB_ATLAS_VERSION}_linux_amd64

FROM hashicorp/terraform:light
LABEL com.fon.version=0.17.4
LABEL com.fon.release-date="2018-0211"
LABEL MAINTAINER="Javier Juarez <javier.juarez@gmail.com>"

ENV MONGODB_ATLAS_VERSION="0.8.1"

RUN mkdir -p /root/.terraform.d/plugins
COPY --from=builder /usr/local/bin/terragrunt /usr/local/bin/
COPY --from=builder /tmp/terraform-provider-mongodbatlas_v${MONGODB_ATLAS_VERSION}_linux_amd64 /root/.terraform.d/plugins

VOLUME ["/src"]
WORKDIR /src

ENTRYPOINT ["/usr/local/bin/terragrunt"]
