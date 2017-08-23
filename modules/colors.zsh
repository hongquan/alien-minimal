#!/usr/bin/env zsh

am_load_colors(){
  if [[ "$AM_USE_TERMINAL_COLOR" == "1" ]]
  then
    am_vcs_color=1
    am_ssh_color=11
    am_normal_color=12
    am_error_color=1
    am_rev_color=14
    am_branch_color=10
    am_dirty_color=2
    am_left_right_color=3
    am_commit_since_color=6
    am_fade_color=8
    am_venv_color=8
    am_python_color=2
    am_ruby_color=1
    am_java_color=15
    am_timer_color=14
  else
    am_vcs_color=248
    am_ssh_color=226
    am_normal_color=39
    am_error_color=208
    am_rev_color=248
    am_branch_color=78
    am_dirty_color=202
    am_left_right_color=222
    am_commit_since_color=244
    am_fade_color=242
    am_venv_color=245
    am_python_color=40
    am_ruby_color=196
    am_java_color=178
    am_timer_color=248
  fi
}

