# Installs NodeJs
include_recipe "nodejs::install_from_package"
include_recipe "nodejs::npm"

# Installs AuthBind
include_recipe "authbind::default"

# Installs manual dependency
package "libfontconfig1" do
  action :install
end

# Installs PhantomJS
execute "install phantomjs" do
  command "npm -g install phantomjs"
end

# Creates PhantomJS user
user "phantomjs" do
  comment "User for running Phantom JS"
  home "/home/phantomjs"
  shell "/bin/bash"
  system true
  action :create
end

# Creates PhantomJS group
group "phantomjs" do
  append true
  members "phantomjs"
  system true
  action :create
end

# Creates PhantomJS home directory
directory "/home/phantomjs" do
  owner "phantomjs"
  group "phantomjs"
  mode "0755"
  action :create
end

# Puts the snapshot script into PhantomJS home
cookbook_file "snapshot-script.js" do
  owner "phantomjs"
  group "phantomjs"
  path "/home/phantomjs/snapshot-script.js"
  mode "0755"
  action :create
end

# Allows PhantomJS to listen on port 80
authbind_port "AuthBind PhantomJS Port 80" do
  port 80
  user 'phantomjs'
  group 'phantomjs'
end

# Creates the PhantomJS service resource
service "phantomjs" do 
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
end

# Puts the PhantomJS service definition into /etc/init
template "phantomjs.conf" do
  path "/etc/init/phantomjs.conf"
  source "phantomjs.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "phantomjs")
end

service "phantomjs" do 
  action [:enable, :start]
end
