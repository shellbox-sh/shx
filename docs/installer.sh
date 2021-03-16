#! /usr/bin/env bash

########################
EMOJI="📜"
REPO_ORG="shellbox-sh"
PROJECT_NAME="shx"
FILE_WITH_VERSION_VARIABLE="shx.sh"
VERSION_VARIABLE="SHX_VERSION"
API_LATEST_RELEASE_INFO_URL="https://api.github.com/repos/$REPO_ORG/$PROJECT_NAME/releases/latest"
FILES_TO_COPY=("shx" "shx.sh")
INSTALL_MESSAGE="Installed 📜 shx.sh

- shx    - Run shx as an executable
- shx.sh - Source shx as a library

  ^--- these files are identical and you may discard either

./shx or 'source shx.sh' to get started rendering templates!

Visit https://shx.shellbox.sh for documentation
"
########################

print_header() {
  echo "$EMOJI [$PROJECT_NAME]"
  echo
}

get_latest_release_version() {
  printf "Checking for latest release... "

  local releaseInfo=""
  releaseInfo="$( curl -s "$API_LATEST_RELEASE_INFO_URL" )"

  if [ $? -ne 0 ]
  then
    echo "failed." >&2
    echo >&2
    echo "(curl -s \"$API_LATEST_RELEASE_INFO_URL\" error)" >&2
    echo "$releaseInfo" >&2
    exit 1
  fi

  local tarballUrl="$( echo "$releaseInfo" | grep tarball | awk '{print $2}' | sed 's/[",]//g' )"

  if [ $? -ne 0 ]
  then
    echo "failed." >&2
    echo >&2
    echo "(read tarball URL from release info failed)" >&2
    echo "$tarballUrl" >&2
    exit 1
  fi

  LATEST_RELEASE_VERSION="${tarballUrl/*\/}"

  echo "$LATEST_RELEASE_VERSION"
}

make_and_goto_tempdir() {
  WORKING_DIRECTORY="$( pwd )"
  TEMP_DIRECTORY="$( mktemp -d )"

  cd "$TEMP_DIRECTORY"
}

download_tarball() {
  printf "Downloading... "
  DOWNLOAD_URL="https://github.com/$REPO_ORG/$PROJECT_NAME/archive/$LATEST_RELEASE_VERSION.tar.gz"
  TARBALL_FILENAME="${DOWNLOAD_URL/*\/}"

  local output=""
  output="$( curl -LO "$DOWNLOAD_URL" 2>&1 )"

  if [ $? -ne 0 ]
  then
    echo "failed, did not successfully to download: $DOWNLOAD_URL" >&2
    echo >&2
    echo "(curl -LO \"$DOWNLOAD_URL\" error)" >&2
    echo "$output" >&2
    exit 1
  elif [ ! -f "$TARBALL_FILENAME" ]
  then
    echo "failed, did not successfully download: $DOWNLOAD_URL (File not found $TARBALL_FILENAME)" >&2
    exit 1
  else
    echo "downloaded $TARBALL_FILENAME"
  fi
}

extract_tarball() {
  printf "Extracting... "

  local output=""
  output="$( tar zxvf "$TARBALL_FILENAME" 2>&1 )"

  if [ $? -ne 0 ]
  then
    echo "failed, could not extract: $TARBALL_FILENAME" >&2
    echo >&2
    echo "(tar zxvf \"$TARBALL_FILENAME\" error)" >&2
    echo "$output" >&2
    exit 1
  else
    echo "extracted $TARBALL_FILENAME"
  fi
}

verify_download() {
  printf "Verifying download... "

  cd $PROJECT_NAME-*

  if [ ! -f "$FILE_WITH_VERSION_VARIABLE" ]
  then
    echo "failed, missing required file: $FILE_WITH_VERSION_VARIABLE" >&2
    exit 1
  fi

  LOCAL_VERIFIED_VERSION=""
  LOCAL_VERIFIED_VERSION="$( grep "$VERSION_VARIABLE=" "$FILE_WITH_VERSION_VARIABLE" | sed "s/.*$VERSION_VARIABLE=//" | sed 's/[";]//g' )"

  if [ $? -ne 0 ]
  then
    echo "failed, could not read version from file: $FILE_WITH_VERSION_VARIABLE" >&2
    echo >&2
    echo "(grep \"$VERSION_VARIABLE\" \"$FILE_WITH_VERSION_VARIABLE\" error)" >&2
    echo "$LOCAL_VERIFIED_VERSION" >&2
    exit 1
  else
    local filename
    for filename in "${FILES_TO_COPY[@]}"
    do
      if [ ! -f "$filename" ]
      then
        echo "failed, missing required file: $filename" >&2
        exit 1
      fi
    done
    echo "verified version $LOCAL_VERIFIED_VERSION"
  fi
}

copy_files_to_working_directory() {
  printf "Installing... "

  local filename
  for filename in "${FILES_TO_COPY[@]}"
  do
    if ! cp "$filename" "$WORKING_DIRECTORY"
    then
      echo "failed, could not copy file to install directory: $filename" >&2
      exit 1
    fi
  done

  echo "installed ${#FILES_TO_COPY[@]} files"
}

cleanup() {
  printf "Cleaning up temporary directory... "

  if ! rm -r "$TEMP_DIRECTORY"
  then
    echo "failed, could not delete temp directory: $TEMP_DIRECTORY" >&2
    exit 1
  fi

  echo "finished"
}

print_footer() {
  echo
  echo "$PROJECT_NAME $LOCAL_VERIFIED_VERSION successfully installed"
  if [ -n "$INSTALL_MESSAGE" ]
  then
    echo
    echo -e "$INSTALL_MESSAGE"
  fi
}

run_install() {
  print_header
  get_latest_release_version
  make_and_goto_tempdir
  download_tarball
  extract_tarball
  verify_download
  copy_files_to_working_directory
  cleanup
  print_footer
}

run_install