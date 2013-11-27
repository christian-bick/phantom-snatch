# Phantom-Snatch

Phantom-Snatch is an out of the box installation for an HTML snapshot service based on PhantomJS. It implements [Google's and Bing's contract](https://support.google.com/webmasters/answer/174992) of indexing Ajax-based webpages in a generalized and scalable way.

## Prerequisites

1. Recent [Ubuntu](http://www.ubuntu.com/) (recommended: Ubuntu 12.04 LTS)
2. Recent [Chef Solo](http://docs.opscode.com/chef_solo.html) (recommended: Chef 11.4)

The provisioning has been tested with AWS Opsworks using Ubuntu 12.04 LTS with Chef 11.4 and Ruby 1.9.3. There is no reason why the provisioning should not also work with newer versions.

## Installation

### Using AWS Opsworks

0. If you don't have an AWS account
  - sign up (it's for free)
  - sign into AWS console
  - choose the OpsWorks service from the menu
1. Create a new stack with the following options
  - Default operating system: Ubuntu 12.04 LTS
  - Chef version: 11.4
  - Use custom Chef cookbooks: yes
    - Repository type: Git
    - Repository URL: git://github.com/bitsuppliers/phantom-snatch
2. Add a new layer of type "Custom" to the stack
3. Edit the created layer using the following options:
  - Chef Recipes
    - Setup: phantomjs
  - Automatically Assign IP Addresses
    - Public IP addresses: yes
    - Elastic IP addresses: yes
4. Add an instance
  - instance size: micro
5. Verify your installation
  - wait until instance status is "online" (pick a coffee)
  - copy your instance's IP address into a browser
  - you know that the installation is complete when the server responds the following:

``
Requests must contain headers "X-Forwarded-Host" and "X-Forwarded-Proto" to evaluate base url
``

### Using chef solo

0. Provide a vanilla Ubuntu
1. Install Git and Chef Solo
2. Clone phantom-snatch ``git clone https://github.com/bitsuppliers/phantom-snatch``
3. Initialize submodules within phantom-snatch ``cd phantom-snatch`` ``git submodule init``
4. Run recipe "phantomjs" with Chef Solo
5. Verify your installation
  - wait until chef run is complete
  - copy your instance's IP adress or hostname into a browser
  - you know that the installation is complete when the server responds the following:

``
Requests must contain headers "X-Forwarded-Host" and "X-Forwarded-Proto" to evaluate base url
``

### Optional installation steps

- to prevent (miss-)use by third parties, you may want to setup an IP-restriction or firewall rules for your intance(s)
- to provide redundancy or scalability, you may want to spawn multiple instances and add a load balancer
- to not rely on IPs, you may want to assign a hostname for your instance(s) (e.g. snapshots.example.com)
