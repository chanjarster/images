#!/bin/bash

image_list=$1
repo=$2
registry=$3

if [[ -z "$image_list" ]]; then
  echo "Usage: retag-images.sh <image_list.txt> <repo> <registry>"
  echo >&2 'image_list not specified'
  exit 1
fi

if [[ -z "$repo" ]]; then
  echo "Usage: retag-images.sh <image_list.txt> <repo> <registry>"
  echo >&2 'repo not specified'
  exit 1
fi

if [[ -z "$registry" ]]; then
  echo "Usage: retag-images.sh <image_list.txt> <repo> <registry>"
  echo >&2 'registry not specified'
  exit 1
fi

while read image; do

  if [[ -z "$image" ]]; then
    continue
  fi

  if [[ "$image" == //* ]]; then
    continue
  fi
  # 遇到 !! 就停止
  if [[ "$image" == !!* ]]; then
    break
  fi

  # group log
  # https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#grouping-log-lines

  echo "::group::Sync $image"
  
  docker pull "$image"

  if [[ $? == 0 ]]; then
    echo "Pull SUCCESS: $image"
  else
    echo "Pull FAILED: $image"
  fi

  new_image="$registry"/"$repo"/"$image"
  
  docker tag "$image" "$new_image"
  if [[ $? == 0 ]]; then
    echo "Retag SUCCESS: $image => $new_image"
  else
    echo "Retag FAILED: $image => $new_image"
    continue
  fi

  docker push "$new_image"
  if [[ $? == 0 ]]; then
    echo "Sync SUCCESS: $new_image"
  else
    echo "Sync FAILED: $new_image"
  fi
  
  docker image rm "$new_image"
  docker image rm "$image"
  docker image prune -f
  
  echo "::endgroup::"
  
done < "$image_list"