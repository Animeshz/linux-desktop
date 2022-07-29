# To reflect the changes run: "set -e fish_initialized" and open another fish-shell

if not set -q fish_initialized
    abbr nqq notepadqq
    abbr pmem 'sudo ps_mem'
    abbr xi 'sudo xbps-install'
    abbr xp 'sudo xbps-pkgdb'
    abbr xq 'xbps-query -Rs'
    abbr xf 'xbps-query -Rf'
    abbr xr 'sudo xbps-remove -R'
    set -U fish_initialized
end
