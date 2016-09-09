FROM tomcat:7

MAINTAINER Bryan Belanger bbelanger@azcender.com

COPY tomcat.txt /etc/facter/facts.d/

ENV PATH /opt/puppetlabs/bin:$PATH

WORKDIR /tmp

RUN apt-get -y update
RUN apt-get -y install git
#RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb
#RUN dpkg -i puppetlabs-release-pc1-jessie.deb
RUN apt-get -y update
RUN apt-get -y install ruby
RUN apt-get -y install libaugeas-ruby
RUN gem install puppet
RUN mkdir -p /etc/puppetlabs/code/environments/production
RUN git clone https://bryanjbelanger-puppet:zGc9Zh5wUfvn@github.com/autostructure/control-repo.git
RUN mkdir -p /etc/puppetlabs/puppet
RUN cp -R /tmp/control-repo/hieradata /etc/puppetlabs/code/environments/production/
RUN puppet module install puppetlabs-tomcat
RUN puppet module install autostructure-artifactory_utils
RUN cp /tmp/control-repo/site/profile/files/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml
RUN cp -R /tmp/control-repo/site/role /etc/puppetlabs/code/environments/production/modules
RUN cp -R /tmp/control-repo/site/profile /etc/puppetlabs/code/environments/production/modules
RUN puppet apply /tmp/control-repo/manifests/site.pp
#RUN apt-get -y purge puppet
#RUN apt-get -y autoremove
#RUN rm -rf /etc/puppet
#RUN rm -rf /etc/puppetlabs
