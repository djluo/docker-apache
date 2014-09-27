# apache
#
# Version 1

FROM centos
MAINTAINER djluo <dj.luo@baoyugame.com>

RUN rpm --import /etc/pki/rpm-gpg/RPM*
RUN yum install -y httpd && yum update -y && yum clean all

EXPOSE 80

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
