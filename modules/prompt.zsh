#!/usr/bin/env zsh

version_prompt(){
  if [[ ! -z "$AM_VERSIONS_PROMPT" ]]
  then
    LOOP_INDEX=0
    for _v in $AM_VERSIONS_PROMPT
    do
      [ "$LOOP_INDEX" != "0" ] && echo -ne "%F{$am_fade_color}|%f"
      [ "$LOOP_INDEX" = "0" ] && LOOP_INDEX=$(($LOOP_INDEX + 1)) && echo -ne "%F{$am_fade_color}[%f"
      [ "$_v" = "PYTHON" ] && echo -ne "`am_python_version`"
      [ "$_v" = "RUBY" ] && echo -ne "`am_ruby_version`"
      [ "$_v" = "JAVA" ] && echo -ne "`am_java_version`"
      [ "$_v" = "GO" ] && echo -ne "`am_go_version`"
      [ "$_v" = "CRYSTAL" ] && echo -ne "`am_crystal_version`"
      [ "$_v" = "NODE" ] && echo -ne "`am_node_version`"
      [ "$_v" = "PHP" ] && echo -ne "`am_php_version`"
    done
    [ "$LOOP_INDEX" != "0" ] && echo -ne "%F{$am_fade_color}]%f"
  fi
}

am_r_prompt(){
  if [[ $(am_is_git) == 1 ]]; then
    echo -ne "`am_bg_count``am_git_rebasing`%F{$am_vcs_color}${AM_GIT_SYM}:%f`am_git_branch``am_git_left_right``am_git_dirty`"
  elif [[ $(am_is_hg) == 1 ]]; then
    echo -ne "`am_bg_count`%F{$am_vcs_color}${AM_HG_SYM}:%f`am_hg_branch` `am_hg_rev`"
  elif [[ $(am_is_svn) == 1 ]]; then
    echo -ne "`am_bg_count`%F{$am_vcs_color}${AM_SVN_SYM}:%f`am_svn_rev`"
  else
    echo -ne "`am_bg_count`"
  fi
}

function am_prompt_general_short_dir(){
  end_tag="%F{$PROMPT_END_TAG_COLOR}${PROMPT_END_TAG}%f"
  if [[ $AM_ERROR_ON_START_TAG == 1 && $PROMPT_START_TAG != "" ]]; then
    start_tag="%(?.%F{$PROMPT_START_TAG_COLOR}${PROMPT_START_TAG}%f.%F{$am_error_color}${PROMPT_START_TAG}%f)"
    echo -ne "${start_tag}"
    echo -ne "%F{$am_normal_color}%1~%f${end_tag}"
  else
    start_tag="%F{$PROMPT_START_TAG_COLOR}${PROMPT_START_TAG}%f"
    echo -ne "${start_tag}"
    echo -ne "%(?.%F{$am_normal_color}%1~%f${end_tag}.%F{$am_error_color}%B%1~%b%f${end_tag})"
  fi
  [[ $AM_HIDE_EXIT_CODE -ne 1 ]] && echo -ne "%(?.. %F{$am_fade_color}%?%f)"
}

function am_prompt_general_long_dir(){
  end_tag="%F{$PROMPT_END_TAG_COLOR}${PROMPT_END_TAG}%f"
  if [[ $AM_ERROR_ON_START_TAG == 1 && $PROMPT_START_TAG != "" ]]; then
    start_tag="%(?.%F{$PROMPT_START_TAG_COLOR}${PROMPT_START_TAG}%f.%F{$am_error_color}${PROMPT_START_TAG}%f)"
    echo -ne "${start_tag}"
    echo -ne "%F{$am_normal_color}%~%f${end_tag}"
  else
    start_tag="%F{$PROMPT_START_TAG_COLOR}${PROMPT_START_TAG}%f"
    echo -ne "${start_tag}"
    echo -ne "%(?.%F{$am_normal_color}%~%f${end_tag}.%F{$am_error_color}%B%~%b%f${end_tag})"
  fi
  [[ $AM_HIDE_EXIT_CODE -ne 1 ]] && echo -ne "%(?.. %F{$am_fade_color}%?%f)"
}

# current working directory, abbreviated (the magic part)
function am_section_pwd() {
  local p="$(print -nP '%/')"
  local o=""

  if [[ $p == / ]]; then
    o+='/'
  else
    [[ $p == $HOME/* || $p == $HOME ]] && p=${p#${HOME}} && o+='~'

    for d in ${(s:/:)p}; do
      [[ "${d:0:1}" == "." ]] && o+="/${d:0:2}" || o+="/${d:0:1}"
    done

    [[ "${d:0:1}" == "." ]] && o+="${d:2}" || o+="${d:1}"
  fi
  end_tag="%F{$PROMPT_END_TAG_COLOR}${PROMPT_END_TAG}%f"
  start_tag="%F{$PROMPT_START_TAG_COLOR}${PROMPT_START_TAG}%f"
  echo -ne "%(?.%F{$am_normal_color}$o%f${end_tag}.%F{$am_error_color}%B$o%b%f${end_tag})"
}

function am_prompt_complete(){
  if [[ $AM_UPDATE_L_PROMPT == 1 ]];then
    if [[ ${AM_INITIAL_LINE_FEED} == 1 ]]; then
      PROMPT='
`am_ssh_st`$__time`am_venv` `am_prompt_general_short_dir` '
    elif [[ ${AM_INITIAL_LINE_FEED} == 2 && $AM_EMPTY_BUFFER == 1 ]]; then
      PROMPT='
`am_ssh_st`$__time`am_venv` `am_prompt_general_short_dir` '
    else
      PROMPT='`am_ssh_st`$__time`am_venv` `am_prompt_general_short_dir` '
    fi
    zle && zle reset-prompt
  fi
  RPROMPT='`am_r_prompt`'
  zle && zle reset-prompt
  async_stop_worker prompt -n
  unset AM_EMPTY_BUFFER
}

function am_section_logon() {
  print -n "%F{$am_php_color}%m@%n%f"
}

function am_last_exit_status() {
  [[ $AM_HIDE_EXIT_CODE -ne 1 ]] && echo -ne "%(?..%F{$am_fade_color}%? %f)"
}
