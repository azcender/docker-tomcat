FROM tomcat:latest

MAINTAINER Bryan Belanger bbelanger@azcender.com

#RUN yum -y upgrade
#RUN yum -y localinstall http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm;
#RUN yum -y install puppet-agent
#RUN mkdir -p /etc/facter/facts.d/

RUN apt-get -y update; \
    curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb; \
    dpkg -i puppetlabs-release-pc1-jessie.deb; \
    apt-get -y install puppet

WORKDIR /etc/puppetlabs/code

ENV PATH /opt/puppetlabs/bin:$PATH

COPY tomcat.txt /etc/facter/facts.d/

COPY hiera.yaml /etc/puppetlabs/code/

COPY environment /etc/puppetlabs/code/environments/production

WORKDIR /tmp

COPY environment/manifests/site.pp /tmp/

RUN puppet apply site.pp

# RUN rm -rf /etc/puppetlabs/code

# CMD ["/opt/tomcat/bin/catalina.sh", "run"]

# EXPOSE 8080
