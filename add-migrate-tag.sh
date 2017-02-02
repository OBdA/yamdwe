#/bin/sh

set -e
set -u

# set defaults
: ${DWPAGE:=/usr/share/dokuwiki/bin/dwpage.php}
: ${MIGRATION_TAG:=mw2dw-migration}

add_migration_tag() {
	local file
	file="$1"

	if grep -E -q '^{{tag>' "$file"; then
		sed -r -i "s/^\{\{tag>/{{tag>$MIGRATION_TAG /" "$file"
	else
		echo "{{tag>$MIGRATION_TAG}}" >> "$file"
	fi
}

tmp=$(mktemp)
while read page; do
	$DWPAGE checkout "$page" "$tmp"
	add_migration_tag "$tmp"
	$DWPAGE commit "$tmp" "$page"
done

#EOF
