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
 *  --output-path
 *      Optional. Path to write the Vagrantfile.
 *      Default behaviour is to output the new Vagrantfile to the screen.
 *
 *  --readme-path
 *      Optional. Path to the readme file
 */

$defaults = [
    'PROJECT_ROOT'  => '.',
    'HTTP_PORT'     => '8080',
    'HTTP_HOST'     => 'localdev',
    'MYSQL_PORT'    => '3306',
    'VBOX_MEMORY'   => '1024',
    'VBOX_CPUS'     => '1',
    'EXTRA_RECIPES'	=> '',
];

define('DS', DIRECTORY_SEPARATOR);

$config = $defaults;

// Misc configuration
$vagrantfile_template   = '.local'.DS.'Vagrantfile-template';
$readme_start_marker    = 'VC-START';
$readme_end_marker      = 'VC-END';

/**
 * Command line arguments
 */
$shortopts  = "";
$longopts  = array(
    "readme-path::",
    "output-path::",
    "dry-run",
);
$options = getopt($shortopts, $longopts);

$cwd = getcwd();

/**
 * Set project root directory to current working dir
 */
$config['PROJECT_ROOT'] = $cwd;

/**
 * Get README path from either cli argument or readme file in current dir.
 */
if (isset($options['readme-path'])) {
    if (is_file($options['readme-path'])) {
        $readme_path = $options['readme-path'];
    }
    else {
        fwrite(STDERR, "ERROR: Specified readme-path not a file or could not be located\n");
        exit(1);
    }
}
else {
    $glob = glob($cwd.DS.'*');
    $paths = preg_grep('/README/i', $glob);
    $readme_path = array_pop($paths);
}

/**
 * Parse the README file for configuration values.
 */

$readme = array_map('trim',file($readme_path));
$start = array_search ($readme_start_marker, $readme);
$end = array_search ($readme_end_marker, $readme);
$readme_config = array_slice($readme, $start+1, $start-$end, false);
foreach ( $readme_config as $line ) {
    $i = explode('=', $line);
    $name = trim($i[0]);
    $value = trim($i[1]);
    $config[$name] = $value;
}


/**
 * Prompt users for input and parse by looping over a set of config descriptions
 * and their related config slug.
 */

fwrite(STDOUT, "\n\nConfiguring your Vagrant instance. Hit enter to use [default] value.\n\n");

function parse_input ( $input, $default ) {
    $input = trim($input);
    if (!empty($input))
        return $input;
    else
        return $default;
}

foreach ([
    'PROJECT_ROOT'  => 'Project root dir',
    'HTTP_PORT'     => 'Project HTTP Port',
    'HTTP_HOST'     => 'HTTP Hostname',
    'MYSQL_PORT'    => 'MySQL Port',
    'VBOX_MEMORY'   => 'Virtual Box Guest Memory',
    'VBOX_CPUS'     => 'Virtual Box Guest CPUs',
    ] as $var => $desc ) {

    fwrite(STDOUT, sprintf('%s [%s]: ', $desc, $config[$var]));
    $input = fgets(STDIN);
    $config[$var] = parse_input($input, $config[$var]);
}

/**
 * Read Vagrantfile template and replace placeholders with config values.
 * Output to screen.
 */
$template = file_get_contents($cwd.DS.$vagrantfile_template);
$search = array_map(
            function($key){ return '%%'.$key.'%%'; },
            array_keys($config)
        );
$replace = array_values($config);
$vagrantfile = str_replace($search, $replace, $template);

/**
 * Output the new Vagrantfile contents
 */
fwrite(STDOUT, "\New Vagrantfile");
fwrite(STDOUT, "\n========================================");
fwrite(STDOUT, "\n".$vagrantfile);
fwrite(STDOUT, "\n========================================");


/**
 * Dry-run creation of Vagrant file outputs it to screen.
 */

if (isset($options['dry-run'])) {
    fwrite(STDOUT, "\nDry Run enabled - Exiting without creating Vagrantfile\n");
    exit(0);
}

$output_path = $cwd . DS . 'Vagrantfile';

if (!file_exists($output_path) || is_writable($output_path)) {
    file_put_contents($output_path, $vagrantfile);
}
else {
    fwrite(STDERR, "ERROR: Vagrantfile cannot be written\n");
    exit(1);
}




// Exit correctly
exit(0);



