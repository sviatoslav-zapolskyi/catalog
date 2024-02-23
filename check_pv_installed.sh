if ! pv --version &>/dev/null
then
  cat <<EOT
  pv is not installed, run:

  brew install pv
EOT

  exit 1
fi
