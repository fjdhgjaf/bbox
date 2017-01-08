<?php
if ($_GET){
        if ($_GET["x1"] == "rpc"){
                $filearray0 = file_get_contents("/etc/bbox/users/".$_GET["fhnev"].".info", true);
                $filearray = explode("\n", file_get_contents("/etc/bbox/users/".$_GET["fhnev"].".info", true));
                if ($filearray0[0]){
                foreach ($filearray as $value) {
                        if (preg_match('/^RPC:/i', $value)) {
                                echo substr($value, 5);;
                        }
                }
                }else{
                        $filearray = explode("\n", file_get_contents("/etc/hostdz/users/".$_GET["fhnev"].".info", true));
                        foreach ($filearray as $value) {
                                if (preg_match('/^RPC:/i', $value)) {
                                        echo substr($value, 5);;
                                }
                        }
                }
        }
}elseif($_POST){
	if ($_POST["ApiKey"] == md5("{$_POST["fhnev"]}=|rb|=fhrestart") AND !empty($_POST["fhnev"])){
		$filearray = file_get_contents("/var/www/rutorrent/conf/users/{$_POST["fhnev"]}/access.ini", true);
		if ($filearray[0]){
			shell_exec("bash reboot_bbuser {$_POST["fhnev"]} {$_POST["irssi"]} > /dev/null 2>&1 &");
			echo "ok";
		}else
			echo "Not found user with id";
	}elseif ($_POST["ApiKey"] == md5($_POST["fhnev"]."=|fletrehoz|=".$_POST["fhnev"]."=|fletrehoz|=") AND !empty($_POST["fhnev"]) AND !empty($_POST["fhjelszo"]) AND !empty($_POST["TarhelyMerete"])){
		print_r($_POST);
		shell_exec("bash createSeedboxUser {$_POST["fhnev"]} {$_POST["fhjelszo"]} > /dev/null 2>&1 &");
		sleep(5);
		shell_exec("sudo setquota -u {$_POST["fhnev"]} {$_POST["TarhelyMerete"]} {$_POST["TarhelyMerete"]} 0 0 -a > /dev/null 2>&1 &");
		sleep(1);
		if ($TarhelyMerete !== 314572800 AND $TarhelyMerete !== 629145600)
			shell_exec("cp /var/www/rutorrent/conf/alap_plugins.ini /var/www/rutorrent/conf/users/{$_POST["fhnev"]}/plugins.ini > /dev/null 2>&1 &");
		echo "ok";
	}elseif ($_POST["ApiKey"] == md5($_POST["fhnev"]."=|fhtorles|=".$_POST["fhnev"]."=|fhtorles|=") AND !empty($_POST["fhnev"])){
		$filearray = file_get_contents("/var/www/rutorrent/conf/users/{$_POST["fhnev"]}/access.ini", true);
		if ($filearray[0]){
			shell_exec("bash deleteSeedboxUser {$_POST["fhnev"]} > /dev/null 2>&1 &");
			echo "ok";
		}else
			echo "Not found user with id";
	}elseif ($_POST["ApiKey"] == md5($_POST["fhnev"]."=|fhjcsere|=".$_POST["fhnev"]."=|fhjcsere|=") AND !empty($_POST["fhnev"]) AND !empty($_POST["fhjelszo"])){
		$filearray = file_get_contents("/var/www/rutorrent/conf/users/{$_POST["fhnev"]}/access.ini", true);
		if ($filearray[0]){
			shell_exec("bash changeUserPassword {$_POST["fhnev"]} {$_POST["fhjelszo"]} rutorrent > /dev/null 2>&1 &");
			echo "ok";
		}else
			echo "Not found user with id";
	}elseif ($_POST["ApiKey"] == md5($_POST["fhnev"]."=|TeljesTorlesAdmin|=".$_POST["fhnev"]."=|TeljesTorlesAdmin|=") AND !empty($_POST["fhnev"]) AND !empty($_POST["x1"])){
		$filearray = file_get_contents("/var/www/rutorrent/conf/users/{$_POST["fhnev"]}/access.ini", true);
		if ($filearray[0]){
			if ($_POST["x1"] == "rut"){
				shell_exec("rm -f -r /var/www/rutorrent/share/users/{$_POST["fhnev"]}/settings/ > /dev/null 2>&1 &");
				echo "ok";				
			}elseif($_POST["x1"] == "teljes"){
				shell_exec("cd /var/www/ && wget -N https://raw.githubusercontent.com/fjdhgjaf/bbox/v1/egyeb/TeljesAdatTorles && sleep 1 && bash TeljesAdatTorles {$_POST["fhnev"]}");
				echo "ok";
			}
		}else
			echo "Not found user with id";
	}elseif ($_POST["ApiKey"] == md5($_POST["fhnev"]."=|update_bbuplugin|=".$_POST["fhnev"]."=|update_bbuplugin|=") AND !empty($_POST["fhnev"]) AND !empty($_POST["x1"])){
		$filearray = file_get_contents("/var/www/rutorrent/conf/users/{$_POST["fhnev"]}/access.ini", true);
		if ($filearray[0]){
			echo shell_exec("bash update_bbuplugin {$_POST["fhnev"]} {$_POST["x1"]} > /dev/null 2>&1 &");
		}else
			echo "Not found user with id";
	}else
		echo 'jsonBestBoxApi({"stat": "fail","id":"101","message":"apiKey is wrong"})';
}else
	echo 'jsonBestBoxApi({"stat": "fail","id":"101","message":"apiKey is wrong"})';
?>
