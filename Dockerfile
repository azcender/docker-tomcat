FROM tomcat:latest

MAINTAINER Bryan Belanger bbelanger@azcender.com

COPY tomcat.txt /etc/facter/facts.d/

ENV PATH /opt/puppetlabs/bin:$PATH

WORKDIR /etc/puppetlabs/code

RUN apt-get -y update; \
  && curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb; \
  && dpkg -i puppetlabs-release-pc1-jessie.deb; \
  && apt-get -y install puppet \
  && puppet module install puppetlabs-stdlib \
  && puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp \
  && apt-get -y purge puppet \
  && apt-get -y autoremove

#COPY environment/manifests/site.pp /tmp/

#RUN puppet apply site.pp
