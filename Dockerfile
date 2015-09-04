FROM centos:latest

MAINTAINER Bryan Belanger bbelanger@azcender.com

RUN yum -y upgrade
RUN yum -y localinstall http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm;
RUN yum -y install puppet-agent
RUN mkdir -p /etc/facter/facts.d/

WORKDIR /etc/puppetlabs/code

ENV PATH /opt/puppetlabs/bin:$PATH

COPY tomcat.txt /etc/facter/facts.d/

COPY hiera.yaml /etc/puppetlabs/code/

COPY hieradata /etc/puppetlabs/code/hieradata
COPY environment/modules /etc/puppetlabs/code/modules

WORKDIR /tmp

COPY environment/manifests/site.pp /tmp/

RUN puppet apply site.pp

RUN rm -rf /etc/puppetlabs/code

CMD ["/opt/tomcat/bin/catalina.sh", "run"]

EXPOSE 8080
