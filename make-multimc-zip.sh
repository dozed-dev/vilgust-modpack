#!/usr/bin/env bash
set -eu

src="$(dirname -- "$(realpath -e -- "$0")")"

packwiz_jars_folder="files/packwiz-jars"
function packwiz_installer {
  java -jar "$src/$packwiz_jars_folder/packwiz-installer-bootstrap.jar" \
    --bootstrap-main-jar "$src/$packwiz_jars_folder/packwiz-installer.jar" \
    --bootstrap-no-update \
    "$@"
}

declare -A filelist
filelist=(
  ["instance.cfg"]="files/instance.cfg"
  ["mmc-pack.json"]="files/mmc-pack.json"
  [".minecraft/packwiz-installer-bootstrap.jar"]="$packwiz_jars_folder/packwiz-installer-bootstrap.jar"
  [".minecraft/packwiz-installer.jar"]="$packwiz_jars_folder/packwiz-installer.jar"
)

dest="$src/out"
mkdir -p "$dest"
#trap 'rm -rf -- "$dest"' EXIT

for target in "${!filelist[@]}"; do
  copy_from="$src/${filelist[$target]}"
  copy_to="$dest/$target";
  mkdir -p "$(dirname "$copy_to")"
  cp -T "$copy_from" "$copy_to"
done

cd "$dest/.minecraft"
packwiz_installer -g -s client "$src/packwiz/pack.toml"
cd "$dest"
zip -r "$src/modpack.zip" .
