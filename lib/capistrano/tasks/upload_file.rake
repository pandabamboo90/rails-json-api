namespace :file do
  desc "Upload a file to server"
  task :upload, [:local_file_path] do |t, args|
    local_file_path = args[:local_file_path]
    abs_path = ""

    on roles(:app), in: :sequence, wait: 5 do
      server_file_path = "#{current_path}/tmp"

      within server_file_path do
        abs_path = capture(:pwd)
      end

      upload!(local_file_path, abs_path)
    end
  end
end
