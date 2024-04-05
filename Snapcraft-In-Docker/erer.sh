tryandretry() { "$@" && return; ANSI_RED='\033[0;31m'; ANSI_RESET='\033[0m'; echo "\n${ANSI_RED}Warning! Retrying 2 of 3 for '$*'${ANSI_RESET}\n" >&2; sleep 1; "$@" && return; echo "\n${ANSI_RED}Warning! Retrying 3 of 3 for '$*'${ANSI_RESET}\n" >&2; sleep 1; "$@"; }
tryandretry xxx
tryandretry ls -1




  
  result=0
  count=1
  while [ $count -le 3 ]; do
    [ $result -ne 0 ] && {
      ANSI_RED='\033[0;31m'; ANSI_RESET='\033[0m';
      echo -e "\n${ANSI_RED}The command \"$@\" failed. Retrying, $count of 3.${ANSI_RESET}\n" >&2
