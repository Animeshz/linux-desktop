# Configuration
cookbook_path [File.expand_path("cookbooks", __dir__),
               File.expand_path("providers", __dir__)]
json_attribs File.expand_path("solo.json", __dir__)

# Temporary paths
checksum_path File.expand_path("tmp/checksums", __dir__)
file_backup_path File.expand_path("tmp/backups", __dir__)
file_cache_path File.expand_path("tmp/cache", __dir__)
node_path File.expand_path("tmp/nodes", __dir__)

# No need to generate a file on disk for this. Just use a dummy UUID.
chef_guid "f3190710-a78f-4dad-86cf-ebbd3a6ec81e"

# log_level        :debug  # :info
# verbose_logging  true    # false
