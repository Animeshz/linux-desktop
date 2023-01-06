setup:
    sudo gem install puppet r10k
    sudo r10k puppetfile install

# call with '--noop' for dry-run
apply *args:
    sudo puppet apply manifests/framework.pp --modulepath modules:/etc/puppet/modules {{args}}