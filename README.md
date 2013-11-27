# Phantom-Snatch

Phantom-Snatch is an out of the box installation for an HTML snapshot service based on PhantomJS. It implements [Google's and Bing's contract](https://support.google.com/webmasters/answer/174992) of indexing Ajax-based webpages in a generalized and scalable way.

## Prerequisites

1. Recent [Ubuntu](http://www.ubuntu.com/) (recommended: Ubuntu 12.04 LTS)
2. Recent [Chef Solo](http://docs.opscode.com/chef_solo.html) (recommended: Chef 11.4)

The provisioning has been tested with AWS Opsworks using Ubuntu 12.04 LTS with Chef 11.4 and Ruby 1.9.3. There is no reason why the provisioning should not also work with newer versions.
