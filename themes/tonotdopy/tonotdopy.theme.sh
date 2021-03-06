#!/usr/bin/env bash

# NOTE: if you need to `echo` or `printf` some colors please use echo_{colors}
# for PS1 please user {colors}

echo_dark_gray="\033[2;49;39m"

SCM_THEME_PROMPT_PREFIX=" ${purple}["
SCM_THEME_PROMPT_SUFFIX=" ${normal}"
SCM_THEME_PROMPT_DIRTY=" ${red}✗${purple}]"
SCM_THEME_PROMPT_CLEAN=" ${green}✓${purple}]"
SCM_GIT_SHOW_DETAILS="false"

CONDAENV_THEME_PROMPT_PREFIX="("
CONDAENV_THEME_PROMPT_SUFFIX=") "
VIRTUALENV_THEME_PROMPT_PREFIX="("
VIRTUALENV_THEME_PROMPT_SUFFIX=") "
PYTHON_THEME_PROMPT_SUFFIX="» "
PYTHON_THEME_PROMPT_PREFIX="«"
# PYTHON_THEME_PROMPT_SUFFIX="• "
# PYTHON_THEME_PROMPT_PREFIX="•"


# THEME_BATTERY_PERCENTAGE_CHECK=true
COMMAND_STATUS_PROMPT_SUCCESS_SURFIX=""
COMMAND_STATUS_PROMPT_SUCCESS_PREFIX="${normal}${green}"
COMMAND_STATUS_PROMPT_FAILD_SURFIX=""
COMMAND_STATUS_PROMPT_FAILD_PREFIX="${normal}${red}"
# COMMAND_STATUS_PROMPT_SUCCESS=""
# COMMAND_STATUS_PROMPT_FAILD=""
# COMMAND_STATUS_PROMPT_SUCCESS=" 😁"
# COMMAND_STATUS_PROMPT_FAILD=" 😵"
# COMMAND_STATUS_PROMPT_SUCCESS="✔"
# COMMAND_STATUS_PROMPT_FAILD="✘"
# COMMAND_STATUS_PROMPT_SUCCESS="⬢"
# COMMAND_STATUS_PROMPT_FAILD="⬡"

PROMPT_RIGHT_PREFIX="${echo_dark_gray}["
# PROMPT_RIGHT_PREFIX="${echo_normal}${echo_underline_orange}["
# PROMPT_RIGHT_PREFIX="${normal}${underline_orange}["
PROMPT_RIGHT_SURFIX="]"

PROMPT_RIGHT_SHOW_CLOCK=true

PROMPT_SYMBOL="⤏"

# function conda_prompt_info(){
#   if [ -n "$CONDA_DEFAULT_ENV" ]; then
#     echo -n "($CONDA_DEFAULT_ENV) "
#   else
#     echo ""
#   fi
# }

print_pad() {
  # num=$1
  v=$(printf "%-${COLUMNS}s" "-")
  echo -ne "${echo_dark_gray}${v// /-}${reset_color}"
}

function command_status(){
    local sta
    local lengs
    lengs=$1
    if [[ $RETVAL -ne 0 ]]; then
      sta="${COMMAND_STATUS_PROMPT_FAILD_PREFIX}${COMMAND_STATUS_PROMPT_FAILD}${COMMAND_STATUS_PROMPT_FAILD_SURFIX}"
    else
      sta="${COMMAND_STATUS_PROMPT_SUCCESS_PREFIX}${COMMAND_STATUS_PROMPT_SUCCESS}${COMMAND_STATUS_PROMPT_SUCCESS_SURFIX}"
    fi

    echo -n "$sta"
}

function command_status_symbol_length(){
    local command_length
    if [[ $RETVAL -ne 0 ]]; then
      command_length=${#COMMAND_STATUS_PROMPT_FAILD}
    else
      command_length=${#COMMAND_STATUS_PROMPT_SUCCESS}
    fi

    echo -n "$command_length"
}

function rightprompt() {
    # set -ex
    local status
    # local command_length
    # tput sc
    status=$(command_status)
    command_length=$(command_status_symbol_length)
    content="${PROMPT_RIGHT_PREFIX}$(date +'%Y/%m/%d-%H:%M:%S')${PROMPT_RIGHT_SURFIX}${status}"
    # content="$(echo -e ${PROMPT_RIGHT_PREFIX}$(date +'%Y/%m/%d-%H:%M:%S')${PROMPT_RIGHT_SURFIX}${status})"
    # printf ""
    # printf "%*s" $(($COLUMNS + ${#PROMPT_RIGHT_PREFIX} + ${#PROMPT_RIGHT_SURFIX} + ${#status} + ${command_length} - 2)) $content
    tmp=$(printf "%*s" $(($COLUMNS + ${#PROMPT_RIGHT_PREFIX} + ${#PROMPT_RIGHT_SURFIX} + ${#status} + ${command_length} - 2)) $content)
    echo -ne "${echo_dark_gray}${tmp// /-}${reset_color}"
    # tput rc
    # set +ex
}

function auto_blank(){
  local ff
  ff=$(scm_prompt_info)
  if [ -z "$ff" ]; then
    echo -ne " "
  else
    echo -ne ""
  fi
}

function prompt_command() {
  # set -ex
  RETVAL=$?
  # PS1="${normal}${blue}$(python_version_prompt)${yellow}\u${normal}${cyan}@\h${normal}${purple} ${normal}${underline_green}\w${normal}$(scm_prompt_info) >>> "
  PYTHON_INFO="${normal}${blue}$(python_version_prompt)"
  HOST_INFO="${yellow}\u${normal}${cyan}@\h${normal}${purple}"
  WORK_DIR_INFO="${normal}${underline_green}\w"
  # PS1="$(print_pad)$(rightprompt)\n${PYTHON_INFO}${HOST_INFO} ${WORK_DIR_INFO}${normal}$(scm_prompt_info)$(auto_blank)➜ ${reset_color}"
  PS1="$(rightprompt)\n${PYTHON_INFO}${HOST_INFO} ${WORK_DIR_INFO}${normal}$(scm_prompt_info)$(command_status)$(auto_blank)${PROMPT_SYMBOL} ${reset_color}"
  # PS1="${PYTHON_INFO}${HOST_INFO} ${WORK_DIR_INFO}${normal}$(scm_prompt_info)$(command_status)$(auto_blank)➜ ${reset_color}"
  # PS1="${PYTHON_INFO}${HOST_INFO} ${WORK_DIR_INFO}${normal}$(scm_prompt_info)$(command_status)$(auto_blank)» ${reset_color}"
  
  # PS1="\[$(rightprompt)\]${normal}${blue}$(python_version_prompt)${yellow}\u${normal}${cyan}@\h${normal}${purple} ${normal}${underline_green}\w${normal}$(scm_prompt_info) » "

  # PYTHON_VERSION="$(python_version_prompt_info)"
  # PSR="${PYTHON_VERSION} ${yellow}\u${normal}${cyan}@\h${normal}${purple} ${normal}${green}\w${normal}$(scm_prompt_info)-> "
  # PS1=$PSR

  # PS1="\[$(rightprompt)\]$(prompt_status)${normal}${blue}$(python_version_prompt)${yellow}\u${normal}${cyan}@\h${normal}${purple} ${normal}${underline_green}\w${normal}$(scm_prompt_info) -> "
  # PS1="\[$(rightprompt)\]${normal}${blue}$(condaenv_prompt)${normal}${blue}$(virtualenv_prompt)${yellow}\u${normal}${cyan}@\h${normal}${purple} ${normal}${underline_green}\w${normal}$(scm_prompt_info) -> "
  # PS1="\[$(rightprompt)\]${normal}${blue}$(conda_prompt_info)${yellow}\u${normal}${cyan}@\h${normal}${purple} ${normal}${underline_green}\w${normal}$(scm_prompt_info) -> "
  PS2="$(command_status)${PROMPT_SYMBOL} ${reset_color}"
  # PS2="» "
}

safe_append_prompt_command prompt_command
