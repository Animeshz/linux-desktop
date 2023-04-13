require "pathname"

module Paths
  def self.bin
    Pathname.new("/usr/bin")
  end

  def self.user(name)
    Pathname.new(Dir.home(name))
  end
end
