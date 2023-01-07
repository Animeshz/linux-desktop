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
      execpipe("code --list-extensions 2>/dev/null || vscode --list-extensions 2>/dev/null || code-oss --list-extensions 2>/dev/null") do |pipe|
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

    execute("code --install-extension #{resource_name} 2>/dev/null || vscode --install-extension #{resource_name} 2>/dev/null || code-oss --install-extension #{resource_name} 2>/dev/null")
  end

  # Removes an extension from the vscode.
  def uninstall
    resource_name = @resource[:name]

    execute("code --uninstall-extension #{resource_name} 2>/dev/null || vscode --uninstall-extension #{resource_name} 2>/dev/null || code-oss --uninstall-extension #{resource_name} 2>/dev/null")
  end
end
