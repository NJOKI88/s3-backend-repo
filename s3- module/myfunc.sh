#!/bin/bash

source Myfunctions.sh

PS3="select your workspace [1-3] and press enter: "

select env in dev stage uat
do
  case $env in
    "dev")
       environment;
       workspace;
       creds;
       test;
       break;;
     "stage")
         environment;
         workspace;
         creds;
         apply;
         break;;
     "uat")
       environment;
       workspace;
       test;
       break;;
    *)
 esac
 done
    