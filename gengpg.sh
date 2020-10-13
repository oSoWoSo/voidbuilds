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


function main_menu(){
  

  PS3="Enter a number: "

  select option in "Generate GPG Key" "Export GPG Key" "Import GPG Key" "Sign File" "Quit"
  do
      if [ "${REPLY}" = "1" ];then
        gen_gpg
      
      elif [ "${REPLY}" = "2" ];then
        echo "What key would you like to export?"
        
        gpg --list-keys
        echo "enter the email of the gpg key"
        read EMAIL_ADDRESS

        echo "What do you want to name your file?: "
        read GPG_FILE_NAME
        
        gpg --output "${GPG_FILE_NAME}.asc" --export ${EMAIL_ADDRESS}
      
        
      elif [ "${REPLY}" = "3" ]; then
        gpg --list-keys
        echo -e -n "put the full path and name of the gpg key you want to import"
        read IMPORT_GPG

        gpg --import "${IMPORT_GPG}"
        gpg --list-keys
        return

      elif [ "${REPLY}" = "4" ];then
        if [ ! -f sign-file.sh ];then
          echo "Cannot find the sign file script"
        else

          echo -n "Enter full path of file you want to sign: "
          read FILE_TO_SIGN

          ./sign-file.sh -f "${FILE_TO_SIGN}"
        fi
          

      elif [ "${REPLY}" = "5" ];then
        echo "GoodBye!"
        exit 0
      fi
  done



}

main_menu