#!/usr/bin/env zsh

THEME_ROOT=${0:A:h}

source "${THEME_ROOT}/modules/init.zsh"

source "${THEME_ROOT}/libs/promptlib/activate"
source "${THEME_ROOT}/libs/zsh-async/async.zsh"
source "${THEME_ROOT}/libs/zsh-256color/zsh-256color.plugin.zsh"

source "${THEME_ROOT}/modules/theme.zsh"
source "${THEME_ROOT}/modules/prompt.zsh"

source "${THEME_ROOT}/modules/git.zsh"
source "${THEME_ROOT}/modules/hg.zsh"
source "${THEME_ROOT}/modules/svn.zsh"
source "${THEME_ROOT}/modules/ssh.zsh"
source "${THEME_ROOT}/modules/bgjob.zsh"
source "${THEME_ROOT}/modules/async.zsh"
source "${THEME_ROOT}/modules/versions.zsh"
source "${THEME_ROOT}/modules/timer.zsh"

[[ ${AM_ENABLE_VI_PROMPT} == 1 ]] && source "${THEME_ROOT}/modules/viprompt.zsh"

function preexec(){
  am_preexec_executed=1
  am_timer_start
  [[ $BUFFER == "" ]] && AM_EMPTY_BUFFER=1
}

function precmd(){
  autoload -U add-zsh-hook
  setopt prompt_subst
  am_load_theme
  # __time="`am_get_time_prompt`"
  am_preexec_executed=0
  if [[ $AM_UPDATE_L_PROMPT == 1 ]]; then
    if [[ ${AM_INITIAL_LINE_FEED} == 1 ]]; then
      PROMPT='
`am_ssh_st`$__time`am_venv` `am_prompt_general_long_dir` '
    elif [[ ${AM_INITIAL_LINE_FEED} == 2 && $AM_EMPTY_BUFFER == 1 ]]; then
      PROMPT='
`am_ssh_st`$__time`am_venv` `am_prompt_general_long_dir` '
    else
      PROMPT='`am_ssh_st`$__time`am_venv` `am_prompt_general_long_dir` '
    fi
  elif [[ $AM_SHOW_FULL_DIR == 1 ]]; then
    if [[ ${AM_INITIAL_LINE_FEED} == 1 ]]; then
      PROMPT='
`am_ssh_st`$__time`am_venv` `am_prompt_general_long_dir` '
    elif [[ ${AM_INITIAL_LINE_FEED} == 2 && $AM_EMPTY_BUFFER == 1 ]]; then
      PROMPT='
`am_ssh_st`$__time`am_venv` `am_prompt_general_long_dir` '
    else
      PROMPT='`am_ssh_st`$__time`am_venv` `am_prompt_general_long_dir` '
    fi
  else
    if [[ ${AM_INITIAL_LINE_FEED} == 1 ]]; then
      PROMPT='
`am_ssh_st`$__time`am_venv` `am_prompt_general_short_dir` '
    elif [[ ${AM_INITIAL_LINE_FEED} == 2 && $AM_EMPTY_BUFFER == 1 ]]; then
      PROMPT='
`am_ssh_st`$__time`am_venv` `am_prompt_general_short_dir` '
    else
      PROMPT='`am_last_exit_status``am_venv``am_section_logon` `am_section_pwd` '
    fi
  fi
  RPROMPT='${VIM_PROMPT}'
  am_async_prompt
  am_timer_start
}
