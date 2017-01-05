#!/usr/bin/php
<?php

/**
 * This script generates a Vagrantfile for a given project by searching for
 * a README.md file in the project root directory (same dir as `.git`), and
 * reading some well-formatted data that describes the project.
 *
 * To run this script, issue the following commands from the
 * project root directory:
 *
 * $ php .local/generateVagrantfile.php [options]
 *
 * OPTIONS:
 *
 *  --conf
 *      Optional. Path to the readme file
 */

define('DS', 			DIRECTORY_SEPARATOR);
define('VAGRANT_JSON', 	'vagrant.json');
define('VAGRANT_TMPL', 	'.local/vagrant/Vagrantfile-template');

$defaults = [
    'project_root'  => '.',
    'http_port'     => '8080',
    'http_host'     => 'localdev',
    'mysql_port'    => '3306',
    'vbox_memory'   => '1024',
    'vbox_cpus'     => '1',
    'extra_recipes'	=> '',
];

// very complicated.
$config = $defaults;

// current working directory
$cwd = getcwd();

/**
 * Command line arguments
 */
$args = array_map(
            function($key){ $key .= '::'; return str_replace('_','-',$key); },
            array_keys($defaults)
        );
$shortopts 	= "";
$longopts  	= ["config::", "output::", "dry-run"] + $args;
$options 	= getopt($shortopts, $longopts);

/**
 * Get config path from either cli argument or readme file in current dir.
 */
if (isset($options['conf']) && !is_file($options['conf'])) {
    fwrite(STDERR, "ERROR: Specified config file could not be read\n");
    exit(1);
}

$json_path = (isset($options['conf']))
			? $options['conf']
			: $cwd . DS . VAGRANT_JSON;

/**
 * Parse the vagrant.json config blob
 */
$json_str 	= trim(file_get_contents( $json_path ));
$json 		= json_decode($json_str, true);

/**
 * Create final config values
 */
$config 	= array_merge($defaults, $json);

/**
 * Get config path from either cli argument or readme file in current dir.
 */
$template 	= file_get_contents($cwd.DS.str_replace('/', DS, VAGRANT_TMPL));

/**
 * Prompt users for input and parse by looping over a set of config descriptions
 * and their related config slug.
 */
fwrite(STDOUT, "\n\nConfiguring your Vagrant instance. Hit enter to use [default] value.\n");

function parse_input ( $input, $default ) {
    return (!empty(trim($input))) ? $input : $default;
}

foreach ([

    'project_root'  => 'Project root dir',
    'http_port'     => 'Project HTTP Port',
    'http_host'     => 'HTTP Hostname',
    'mysql_port'    => 'MySQL Port',
    'vbox_memory'   => 'Virtual Box Guest Memory',
    'vbox_cpus'     => 'Virtual Box Guest CPUs',

  	] as $var => $desc ) {

    fwrite(STDOUT, sprintf('%s [%s]: ', $desc, $config[$var]));
    $input = fgets(STDIN);
	$config[$var] = parse_input($input, $config[$var]);
}

/**
 * Read Vagrantfile template and replace placeholders with config values.
 * Output to screen.
 */
$search = array_map(
            function($key){ return '%%'.strtoupper($key).'%%'; },
            array_keys($config)
        );
$replace = array_values($config);
$vagrantfile = str_replace($search, $replace, $template);

/**
 * Output the new Vagrantfile contents
 */
fwrite(STDOUT, "\nNew Vagrantfile");
fwrite(STDOUT, "\n========================================");
fwrite(STDOUT, "\n".$vagrantfile);
fwrite(STDOUT, "\n========================================");
fwrite(STDOUT, "\n");

/**
 * Dry-run creation of Vagrant file outputs it to screen.
 */
if (isset($options['dry-run'])) {
    fwrite(STDOUT, "\nDry Run enabled - Exiting without creating Vagrantfile\n");
    exit(0);
}

$output = $cwd . DS . 'Vagrantfile';

if (file_exists($output) && !is_writable($output)) {
    fwrite(STDERR, "ERROR: Vagrantfile cannot be written\n");
    exit(1);
}

file_put_contents($output, $vagrantfile);

// Exit correctly
exit(0);
