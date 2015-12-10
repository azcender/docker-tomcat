FROM tomcat:latest

MAINTAINER Bryan Belanger bbelanger@azcender.com

COPY tomcat.txt /etc/facter/facts.d/

ENV PATH /opt/puppetlabs/bin:$PATH

WORKDIR /tmp

RUN apt-get -y update \
  && apt-get -y install git \
  && wget https://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb \
  && dpkg -i puppetlabs-release-pc1-jessie.deb \
  && apt-get -y update \
  && apt-get -y install puppet \
  && gem install librarian-puppet --no-ri --no-rdoc \
  && git clone https://bryanjbelanger-puppet:zGc9Zh5wUfvn@github.com/azcender/puppet-r10k-environment.git \
  && cd puppet-r10k-environment \
  && mkdir -p /etc/puppetlabs/code/environments/production \
  && cp -R hieradata /etc/puppetlabs/code/environments/production/ \
  && librarian-puppet install --path /etc/puppet/modules \
  && cp /etc/puppet/modules/profile/files/hiera.yaml /etc/hiera.yaml

RUN puppet apply /tmp/puppet-r10k-environment/manifests/site.pp
#  && apt-get -y purge puppet \
#  && apt-get -y autoremove
