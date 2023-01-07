require "puppet/provider/package"
require "set"
require "uri"

Puppet::Type.type(:package).provide :vscode, :parent => Puppet::Provider::Package do
  desc "VSCode Extension provider to manage extensions on VSCode"
  has_feature :installable, :uninstallable

  # commands :vscode => "/usr/bin/code-oss"

  # Fetch the list of extensions that are currently installed on the vscode.
  def self.instances
    begin
      packages = []
      args = "--list-extensions --no-sandbox --user-data-dir /tmp --extensions-dir $VSCODE_EXTENSIONS 2>/dev/null"
      execpipe("bash -c 'source /etc/environment && code #{args} || vscode #{args} || code-oss #{args}'") do |pipe|
        pipe.each_line do |line|
          packages << new({ name: line.chomp, ensures: 'present', provider: self.name })
        end
      end

      packages
    rescue Puppet::ExecutionFailure
      fail(_("Error getting installed packages"))
    end
  end

  # Queries information for a package
  def query
    resource_name = @resource[:name]
    installed_packages = self.class.instances

    installed_packages.each do |pkg|
      return pkg.properties if @resource[:name].casecmp(pkg.name).zero?
    end

    return nil
  end

  # Install an extension from the vscode.
  def install
    resource_name = @resource[:name]

    args = "--install-extension #{resource_name} --no-sandbox --user-data-dir /tmp --extensions-dir $VSCODE_EXTENSIONS 2>/dev/null"
    execute("bash -c 'source /etc/environment && code #{args} || vscode #{args} || code-oss #{args}'")
  end

  # Removes an extension from the vscode.
  def uninstall
    resource_name = @resource[:name]

    args = "--uninstall-extension #{resource_name} --no-sandbox --user-data-dir /tmp --extensions-dir $VSCODE_EXTENSIONS 2>/dev/null"
    execute("bash -c 'source /etc/environment && code #{args} || vscode #{args} || code-oss #{args}'")
  end
end
