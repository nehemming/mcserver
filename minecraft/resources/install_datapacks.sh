#!/bin/sh
set -e

echo "Creating world folder"
mkdir -p "${world_folder}/datapacks"

echo "Datapack Copying data packs"
[ -e "${server_datapack_folder}/"*.zip ] && cp -v "${server_datapack_folder}/"*.zip "${world_folder}/datapacks"
echo "Datapack Copy complete"