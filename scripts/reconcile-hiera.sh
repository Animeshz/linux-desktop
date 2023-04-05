cd data
hiera_files=$(fd '.ya?ml$' -tf)
cd -
cd modules
module_files=$(fd '.pp$' -tf | sed -e 's/\/manifests//' -e 's/\/init.pp$/.pp/' -e 's/.pp$//' -e 's/\//./g')
cd -

while read file; do
    content=$(cat $file)

    # maybejust use python3
    echo "$content" | yq
done <<< "$hiera_files"

