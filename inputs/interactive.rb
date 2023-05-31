require 'facter'

Facter.add(:my_custom_fact) do
  setcode do
    `gum input --placeholder "scope"`.strip
  end
end

Facter.add(:my_custom_fact2) do
  setcode do
    `
    gum input --placeholder "f2"
    gum input --placeholder "uwu"
    `.strip
  end
end