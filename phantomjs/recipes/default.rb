include_recipe "nodejs"

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

file "snapshot-script.js" do
  owner "phantomjs"
  group "phantomjs"
  path "/home/phantomjs"
  mode "0755"
  action :create
end