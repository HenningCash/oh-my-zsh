function get_gcloud_sdk_path() {
  local bin_path
  bin_path="$(which gcloud)"
  # Try to locate SDK fast from binary location without invoking gcloud.
  # It should be installed in a directory called google-gloud-sdk.
  # This will have nearly no impact on zsh startup time
  if [[ $bin_path =~ '/google-cloud-sdk/bin/gcloud' ]]; then
    echo ${bin_path/\/bin\/gcloud/}
  else
    # Invoking gcloud to find the SDK location will be slow and is only
    # used in case the first method fails
    echo $(gcloud info | grep -oP '(?<=Installation Root: \[)(.+)(?=\])')
  fi
}

if [ $commands[gcloud] ]; then
  sdk_root=$(get_gcloud_sdk_path)
  completion="$sdk_root/completion.zsh.inc"
  # It should not be necessary to include path.zsh.inc as both locate
  # methods require "gcloud" to be in $PATH
  if [ -f $completion ]; then
    source $completion
  fi
fi
