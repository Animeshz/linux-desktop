unified_mode true

actions :sync_clean_master

default_action :sync_clean_master

attribute :repository, kind_of: String
attribute :destination, kind_of: String, name_attribute: true
attribute :user, kind_of: String
attribute :group, kind_of: Stringeson