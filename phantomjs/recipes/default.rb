include_recipe "nodejs::install_from_package"
include_recipe "nodejs::npm"

package "libfontconfig1" do
  action :install
end

execute "install phantomjs" do
  command "npm -g install phantomjs"
end

user "phantomjs" do
  comment "User for running Phantom JS"
  home "/home/phantomjs"
  shell "/bin/bash"
  system true
  action :create
end

group "phantomjs" do
  append true
  members "phantomjs"
  system true
  action :create
end

directory "/home/phantomjs" do
  owner "phantomjs"
  group "phantomjs"
  mode "0755"
  action :create
end

file "snapshot-script.js" do
  owner "phantomjs"
  group "phantomjs"
  path "/home/phantomjs/snapshot-script.js"
  mode "0755"
  action :create
end
