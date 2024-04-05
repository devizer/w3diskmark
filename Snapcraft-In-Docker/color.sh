EchoColored() { ANSI_NC='\033[0m'; ANSI_Color_Green='\033[1;32m'; ANSI_Color_Red='\033[1;31m'; ANSI_Color_Yellow='\033[1;33m'; color="$(eval "echo \$ANSI_Color_${1}")"; shift; if [ -z "$BASH_VERSION" ]; then echo "${color}$*${ANSI_NC}"; else echo -e "${color}$*${ANSI_NC}"; fi; }; \
EchoRedError() { EchoColored Red "\n$*\n"; }; \
EchoColored Green Hello. "I'm" Running
EchoColored Red "Error. Abort"
EchoColored Yellow "Hahaha"

EchoRedError Retry 2 of 3
EchoRedError Retry 3 of 3
EchoColored Yellow "$(ls -lah)"
