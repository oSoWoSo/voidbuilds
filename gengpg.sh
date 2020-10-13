#!/bin/bash

gpgLocation="/usr/bin/gpg"

function gen_gpg(){
  while true;do
    echo -e -n "Do you have a key?[y/n]: "
    read answer

    if [ "${answer}" = "y" ];then
      echo "You're good, nevermind!"
      exit 0

      elif [ "${answer}" = "n" ]; then
        if [ ! -f "${gpgLocation}" ];then
          echo "Please install gnupg (gpg)"
          exit 0
        else
          gpg --gen-key


        fi

    else
      read -p "Please enter y or n"
    fi
  done
  }

  gen_gpg