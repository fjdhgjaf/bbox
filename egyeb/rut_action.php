<?php
##################### FIRST LINE
# ---------------------------
#!/bin/bash
# ---------------------------
#
# |--------------------------------------------------------------|
# | The script thank you for Notos (notos.korsan@gmail.com)      |
# |--------------------------------------------------------------|
# | The script was further developed Tiby08 (tiby0108@gmail.com) |
# |--------------------------------------------------------------|
# | Version info: v0.1 beta                                      |
# |--------------------------------------------------------------|
#
#

  require_once( '../../php/util.php' );

  if(!isset($quotaUser)) {
    $quotaUser = '';
  }
  $topDirectory = "/home"; // Upper available directory. Absolute path with trail slash.
  $homeUser  = $topDirectory.'/'.$quotaUser;
  $homeBase  = $topDirectory;
  $quotaEnabled = FALSE;
  if (isset($quotaUser) and !Empty($quotaUser) and file_exists($homeBase.'/aquota.user')) {
    $quotaEnabled = myGetDirs($quotaUser, &$homeUser, &$homeBase); /// get the real home dir
  }

  if ($quotaEnabled) {
    $total = shell_exec("/usr/bin/sudo /usr/sbin/repquota -u -a | grep ^".$quotaUser." | awk '{print \$4}'") * 1024;
    $used = shell_exec("/usr/bin/sudo /usr/sbin/repquota -u -a | grep ^".$quotaUser." | awk '{print \$3}'") * 1024;

    if ($total == 0) {
      $total = disk_total_space($topDirectory);
    }

    $free = ($total - $used);
  } else {
    $total = disk_total_space($topDirectory);
    $free = disk_free_space($topDirectory);
  }

  cachedEcho('{ "total": '.$total.', "free": ' .$free.' }',"application/json");

  function myGetDirs($username, $homeUser, $homeBase) {
    $passwd = file('/etc/passwd');
    $path = false;
    foreach ($passwd as $line) {
      if (strstr($line, $username) !== false) {
        $parts = explode(':', $line);
        $path = $parts[5];
        break;
      }
    }

    $ret = TRUE;  
    $U = realpath($path); /// expand
    $B = realpath($path."/.."); /// home is the previous path
  
    if (isset($U) and !Empty($U) and is_dir($U)) {
      $homeUser = $U;
    } else {
      $ret = FALSE;
    }
    if (isset($B) and !Empty($B) and is_dir($B)) {
      $homeBase = $B;
    } else {
      $ret = FALSE;
    }

    return $ret;
  }
