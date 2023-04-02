SUDO := `command -v sudo 2>/dev/null || command -v doas 2>/dev/null || true`

export PATH := env_var('PATH') + ":" + `gem env | grep 'EXECUTABLE DIRECTORY' | sed --quiet "s/.*EXECUTABLE DIRECTORY: \(.*\)/\1/p"` + ":" + `gem env | grep 'USER INSTALLATION DIRECTORY' | sed --quiet "s/.*USER INSTALLATION DIRECTORY: \(.*\)/\1/p"` / "bin"

setup:
    {{SUDO}} gem install puppet r10k
    {{SUDO}} r10k puppetfile install

# call with '--noop' for dry-run
apply *args:
    {{SUDO}} puppet apply manifests/framework.pp --hiera_config=hiera.yaml --modulepath modules:/etc/puppet/modules {{args}}

lookup *args:
    puppet lookup --hiera_config=hiera.yaml {{args}}
