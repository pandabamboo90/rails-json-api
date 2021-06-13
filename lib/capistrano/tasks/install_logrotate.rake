namespace :server do
  desc "Setup logrotate for our application"
  task :install_logrotate do
    on roles(:app), in: :sequence, wait: 5 do
      file_content = ""
      abs_shared_dir_path = shared_path
      file_name = "#{fetch(:application)}.conf"

      within shared_path do
        abs_shared_dir_path = capture(:pwd)

        file_content = "#{abs_shared_dir_path}/log/*.log {
  daily
  size 500M
  missingok
  notifempty
  rotate 5
  compress
  delaycompress
  copytruncate
  dateext
}"
      end

      file_path_on_local = "tmp/#{file_name}"
      file_path_on_server = "/etc/logrotate.d/#{file_name}"

      File.open(file_path_on_local, "w") do |f|
        f.write file_content
      end

      upload! file_path_on_local, "#{abs_shared_dir_path}/#{file_name}"

      execute "sudo mv #{abs_shared_dir_path}/#{file_name} #{file_path_on_server}"
      execute "sudo chown root:root #{file_path_on_server}"

      execute "sudo logrotate -f #{file_path_on_server}"
    end
  end
end
