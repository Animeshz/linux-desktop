module Internet
  def self.online?
    @online ||= system('ping -c 1 www.example.com', [:out, :err] => File::NULL)
  end

  def self.offline?
    !online?
  end
end