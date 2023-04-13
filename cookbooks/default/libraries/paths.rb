require "pathname"

module Paths
  def self.bin
    Pathname.new("/usr/bin")
  end
end
