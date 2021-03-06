FROM centos:latest
MAINTAINER Port Direct <support@port.direct>

LABEL license="Apache-2.0" \
      vendor="Port Direct" \
      url="https://port.direct/" \
      vcs-type="Git" \
      vcs-url="https://github.com/portdirect/harbor"

ENV OS_DISTRO="HarborOS" \
    OPENSTACK_COMPONENT="mandracchio-rpm-repo" \
    LC_ALL="en_US.UTF-8" \
    container=docker

LABEL license="Apache 2.0" \
      vendor="Harbor OpenStack"

RUN set -e && \
    set -x && \
    yum install -y \
        epel-release && \
    yum update -y && \
    yum upgrade -y && \
    yum groupinstall -y \
        "Development Tools" && \
    yum install -y \
        openssl-devel \
        ncurses-devel \
        ncurses \
        bc \
        rpmdevtools \
        ruby-devel \
        gcc \
        make \
        git \
        rpm-build \
        httpd \
        createrepo \
        nginx  && \
    yum clean all && \
    rm -rf /usr/share/nginx/html/* && \
    gem install fpm && \
    mkdir -p /srv/repo/atomic-host/7/{SRPMS,i386,x86_64,noarch} && \
    chmod -R 0777 /srv/repo/atomic-host/7/{SRPMS,i386,x86_64,noarch} && \
    useradd user

ADD ./assets /opt/harbor/assets

RUN set -e && \
    set -x && \
    /bin/cp -rf /opt/harbor/assets/* / && \
    cd /tmp && \
    export PACKAGE_NAME="harbor-assets" && \
    export PACKAGE_VERSION="0.1" && \
    export PACKAGE_ARCH="x86_64" && \
    export PACKAGE_URL="https://port.direct" && \
    export ITERATIONS=$(date +%s) && \
    fpm \
      -s dir \
      -t rpm \
    	--after-install /opt/post-install.sh \
      --name $PACKAGE_NAME \
      --log info \
      --verbose \
      --version $PACKAGE_VERSION \
      --iteration $ITERATIONS \
      --architecture $PACKAGE_ARCH \
      --epoch 1 \
      --license "Apache 2.0" \
      --vendor "Harbor OpenStack" \
      --description "${PACKAGE_NAME} package for Harbor Atomic Host" \
      --url $PACKAGE_URL \
      --maintainer "Port Direct" \
    /opt/payload && \
    cp $PACKAGE_NAME-$PACKAGE_VERSION-$ITERATIONS.$PACKAGE_ARCH.rpm /srv/repo/atomic-host/7/$PACKAGE_ARCH/ && \
    rm -rf /srv/repo/atomic-host/7/$PACKAGE_ARCH/repodata && \
    cd /srv/repo/atomic-host/7/$PACKAGE_ARCH && \
      createrepo . && \
    mkdir -p /usr/share/nginx/html/$PACKAGE_ARCH/ && \
    mv /srv/repo/atomic-host/7/$PACKAGE_ARCH/* /usr/share/nginx/html/$PACKAGE_ARCH/

RUN set -e && \
    set -x && \
    PACKAGE_ARCH=noarch && \
    rpmbuild -bb /root/rpmbuild/SPECS/centos-logos.spec && \
    cp /root/rpmbuild/RPMS/${PACKAGE_ARCH}/*.rpm /srv/repo/atomic-host/7/${PACKAGE_ARCH}/ && \
    cd /srv/repo/atomic-host/7/${PACKAGE_ARCH} && \
    createrepo . && \
    mkdir -p /usr/share/nginx/html/${PACKAGE_ARCH}/ && \
    mv /srv/repo/atomic-host/7/${PACKAGE_ARCH}/* /usr/share/nginx/html/${PACKAGE_ARCH}/

ENTRYPOINT []

CMD ["/start.sh"]

LABEL license="Apache-2.0" \
      vendor="Port Direct" \
      url="https://port.direct/" \
      vcs-type="Git" \
      vcs-url="https://github.com/portdirect/harbor" \
      name="%%DOCKER_FULLIMAGE%%" \
      vcs-ref="%%DOCKER_TAG%%" \
      build-date="%%DOCKER_BUILD_DATE%%"
