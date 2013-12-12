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


## Taking snapshots

If you want to take a snapshot of

``https://my.domain/#!/crawlable``

then you can now call

``http://phantom.snatch.hostname/?_escaped_fragment_=/crawlable``

with headers

``X-Forwarded-Proto: https`` and ``X-Forwarded-Host: my.domain``

### Controlling snapshots

Rendering Ajax-Pages has one major pitfall: Because of Ajax's asynchronous behaviour, it is hard for the renderer to say when the page is ready for a snapshot. The most robust and performant way to solve this, is to let the page actively signal that it's ready.

You can signal Phantom-Snatch that the page is ready by setting the attribute data-status in the body tag to "ready":

```
<body data-status="ready">
```

As soon as Phantom-Snatch gets this signal, it will take the snapshot and write its response. If PhantomJS never sees a signal, it will take a snapshot after 5 seconds and return whatever it sees then. Because performance has an impact on page rankings, it's highly recommended to signal Phantom-Snatch page-readyness instead of relying on a timeout.

### Nginx as snapshot proxy

You can make handling snapshots transparent if you use nginx to serve content for "my.domain".

```nginx
location / {
    # Your current configuration for root
    
    proxy_set_header X-Forwarded-Proto https; # should be http or https
    proxy_set_header X-Forwarded-Host $host; # may also be a fixed value
    
    if ($args ~ "_escaped_fragment_=(.*)") {
      proxy_pass http://phantom.snatch.hostname; # Address of your phantom-snatch instance
    }
  }
}
```

Now, nginx will forward every request containing an "\_escaped_fragment_" query parameter to your snapshot server and return the result to the crawler.

### Apache as snapshot proxy

The equivalent is possible with Apache (just missing a tested example).

### Varnish as snapshot proxy

The equivalent is possible with Varnish (just missing a tested example).

## Performance

Tests have shown a pretty good performance for medium-complex pages. On an AWS micro instance (1 Core, 768 MB RAM) the avarage return time varied between 1-2 seconds. Even better results should be possible with instances dedicated to computing.

There is not enough experience yet with larger amounts of load to make final conclusions. Experience so far suggests that you can easily render pages in real time without the need to make screenshots in advance.

This said, it may still be advisable to cache already rendered snapshots on the proxy. Nginx, Apache and Varnish can easily be configured to add caching to their reverse proxy capabilities. This cache can then be prewarmed on deployment or on data changes by just calling the same URL as the crawler would.

## Contributing

Phantom-Snatch is the outcome of a concrete project with a concrete setting. Join us to make Phantom-Snatch useful and helpful for as many people as possible by making hard-coded settings configurable and by modifying chef recipes to support more platforms.

How can you contribute? Fork Phantom-Snatch and make all changes needed to make it work in your environment. Try to stay backward compatible so that we can merge your fork afterwards.

Moreover, feedback like "this worked nice on Ubuntu 13.x" is very welcome.

## Inspired by

### Articles

[Year of Moo](http://www.yearofmoo.com/2012/11/angularjs-and-seo.html)

[Backbone Tutorials](http://backbonetutorials.com/seo-for-single-page-apps/)

### Code

[Year of Moo](https://github.com/yearofmoo-articles/AngularJS-SEO-Article)

[HTML-Snapshots](https://github.com/localnerve/html-snapshots)

[Angular-SEO](https://github.com/steeve/angular-seo)
