timezone = "Asia/Kolkata"

link "Set timezone to: #{timezone}" do
  target_file "/etc/localtime"
  to "/usr/share/zoneinfo/#{timezone}"
end
