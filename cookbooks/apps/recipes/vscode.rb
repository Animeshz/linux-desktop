vscode_bin = Paths.bin.join("code-oss")
extra_opts = "--no-sandbox --user-data-dir /tmp --extensions-dir $VSCODE_EXTENSIONS"

extensions = %w[
  asvetliakov.vscode-neovim
  Equinusocio.vsc-material-theme
  ms-python.python
  ms-vscode.cpptools
  rust-lang.rust-analyzer
]

# Tasks
execute "Install vscode" do
  command "xbps-install -y vscode"
  only_if { Internet.online? }
  not_if { vscode_bin.exist? }
end

extensions.each do |extension|
  execute "Install VSCode extension: #{extension}" do
    command "#{vscode_bin} #{extra_opts} --install-extension #{extension}"
    only_if { Internet.online? }
    only_if { vscode_bin.exist? }
    not_if "#{vscode_bin} #{extra_opts} --list-extensions | grep ^#{extension}$"
  end
end