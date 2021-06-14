#
# List of IPs of your remote servers
# Ex: %w[123.456.789.100 123.456.789.101 123.456.789.102]
#
servers_ip = %w[]
ssh_info_list = []

servers_ip.each do |ip|
  ssh_info_list.push("ubuntu@#{ip}")
end

role :app, ssh_info_list
role :web, ssh_info_list
role :db, ssh_info_list.first
set :ssh_info_list, ssh_info_list
set :ssh_options, {
  keys: "PATH_TO_YOUR_PRIVATE_KEY",
  forward_agent: true,
  auth_methods: %w[publickey]
}

set :branch, "master"
set :rails_env, "production"

#
# For backup & replicate database
# gem "capistrano-db-tasks" configs
#
set :locals_rails_env, "staging"