enable_locales = ["en_US.UTF-8 UTF-8"]
system_locale = "en_US.UTF-8"

# Tasks
enable_locales.each do |locale|
  replace_or_add "Enable locales: #{locale}" do
    path "/etc/default/libc-locales"
    pattern "^#?#{locale}"
    line "#{locale}"
    notifies :run, "execute[Generate enabled locales]"
  end
end

replace_or_add "Set system locale" do
  path "/etc/locale.conf"
  pattern "^LANG="
  line "LANG=\"#{system_locale}\""
end

execute "Generate enabled locales" do
  command "xbps-reconfigure --force glibc-locales"
  action :nothing
end
