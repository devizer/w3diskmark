# bash & sh
EchoRedError() { ANSI_RED='\033[0;31m'; ANSI_RESET='\033[0m'; if [ -z "$BASH_VERSION" ]; then echo "\n${ANSI_RED}$*${ANSI_RESET}\n" >&2; else echo -e "\n${ANSI_RED}$*${ANSI_RESET}\n" >&2; fi; }
RetryOnFail() { "$@" && return; EchoRedError "Retrying 2 of 3 for '$*'"; sleep 1; "$@" && return; EchoRedError "Retrying 3 of 3 for '$*'"; sleep 1; "$@"; }
RetryOnFail xxx
RetryOnFail ls -1




  
  result=0
  count=1
  while [ $count -le 3 ]; do
    [ $result -ne 0 ] && {
      ANSI_RED='\033[0;31m'; ANSI_RESET='\033[0m';
      echo -e "\n${ANSI_RED}The command \"$@\" failed. Retrying, $count of 3.${ANSI_RESET}\n" >&2
