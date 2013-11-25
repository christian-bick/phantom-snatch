include_recipe "nodejs"

execute "install phantomjs" do
  command "npm -g install phantomjs"
end
