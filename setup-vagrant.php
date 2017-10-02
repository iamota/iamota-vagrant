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

define('DS', 				DIRECTORY_SEPARATOR);
define('VAGRANT_JSON', 		'vagrant.json');
define('VAGRANTFILE_TMPL', 	'.local/templates/Vagrantfile.tmpl');


$defaults = [
    'project_root'  => '.',
    'http_port'     => '',
    'http_host'     => 'localhost',
    'mysql_port'    => '3306',
    'vbox_memory'   => '1024',
    'vbox_cpus'     => '1',
    'extra_recipes'	=> '',
    'final_user_message' => '',
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
$longopts  	= ["conf::", "interactive", "echo", "dry-run"] + $args;
$options 	= getopt($shortopts, $longopts);

/**
 * Print Vagrantfile to STDOUT without user prompts or other meta
 */
$echo = (isset($options['echo']));

/**
 * Interactive mode for modifying defaults.
 */
$interactive = (isset($options['interactive']));

/**
 * Get config path from either cli argument or readme file in current dir.
 */
if (isset($options['conf']) && !is_file($options['conf'])) {
    fwrite(STDERR, "ERROR: Specified config file could not be read\n");
    exit(1);
}

// Load JSON config path..
$json_path = (isset($options['conf']))
		? $options['conf'] // ..from commandline argument
		: $cwd . DS . VAGRANT_JSON; // ..or from default location

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
 * Prompt users for input and parse by looping over a set of config descriptions
 * and their related config slug.
 */
if ($interactive) {

	function parse_input ( $input, $default ) {
	    return (!empty(trim($input))) ? $input : $default;
	}

	fwrite(STDOUT, "\n========================================");
	fwrite(STDOUT, "\nGenerating new Vagrantfile!");
	fwrite(STDOUT, "\nBeginning interactive configuration. Hit enter to use [default] value.");
	fwrite(STDOUT, "\n========================================");
	fwrite(STDOUT, "\n\n");

	// Each item below is a prompt for the user.
	// the keys should match the $defaults array above.
	$user_prompt = [
	    'project_root'  => 'Project root dir',
	    'http_host'     => 'HTTP Hostname',
	    'http_port'     => 'Project HTTP Port',
	    'mysql_port'    => 'MySQL Port',
	    'vbox_memory'   => 'Virtual Box Guest Memory',
	    'vbox_cpus'     => 'Virtual Box Guest CPUs',
	];

	foreach ($user_prompt as $var => $desc ) {

		if (empty($desc)) continue; // If value is not truthy, skip this interation.

		$default = (!empty($config[$var])) ? $config[$var] : ''; // blank default

	    fwrite(STDOUT, sprintf('%s [%s]: ', $desc, $default));
	    $input = trim(fgets(STDIN));
		$config[$var] = parse_input($input, $default);
	}
}

/**
 * Handle Extra Chef Recipes
 */
function parse_recipes( $recipes ) {
	$recipes = trim($recipes);
	if (empty($recipes))
		return '';
    $arr = explode(' ', $recipes);
	$arr = array_map(
            function($item){ $item = trim($item); return "chef.add_recipe '{$item}'"; },
            $arr
        );
	$str = implode("\n    ", $arr);
	return $str;
}

$config['extra_recipes'] = parse_recipes($config['extra_recipes']);

/**
 * Add extra messaging to the Vagrantfile, if needed.
 */
$final_user_message = [];

// Configured host isn't localhost or local IP
if (!in_array($config['http_host'], ['localhost', '127.0.0.1'])) {
	$final_user_message[] = 'echo "Important: Add the custom hostname to your hosts file. Shorthand: sudo echo \'127.0.0.1 ' . $config['http_host']. '\' >> /etc/hosts"';
}

// Build the message
$config['final_user_message'] = implode("\n", $final_user_message);

/**
 * Read Vagrantfile template and replace placeholders with config values.
 * Output to screen.
 */
$search = array_map(
            function($key){ return '%%'.strtoupper($key).'%%'; },
            array_keys($config)
        );
$replace = array_values($config);

/**
 * Get config path from either cli argument or readme file in current dir.
 */
$template 		= file_get_contents($cwd.DS.str_replace('/', DS, VAGRANTFILE_TMPL));
$vagrantfile 	= str_replace($search, $replace, $template);

/**
 * If echo-only, output the new Vagrantfile contents to STDOUT and exit
 */
if ($echo) {
	fwrite(STDOUT, $vagrantfile);
	exit(0);
}

/**
 * Otherwise, if this is an interactive session, output the new Vagrantfile
 * contents + helper info to STDOUT.
 */
if ($interactive) {
	fwrite(STDOUT, "\n== New Vagrantfile =========================================");
	fwrite(STDOUT, "\n\n".$vagrantfile);
	fwrite(STDOUT, "\n== End of Vagrantfile ======================================");
	fwrite(STDOUT, "\n");
}

/**
 * Dry-run creation of Vagrant file outputs it to screen.
 */
if (isset($options['dry-run'])) {
    fwrite(STDOUT, "\nDry Run enabled - Exiting without creating Vagrantfile\n");
    exit(0);
}

// Output path for new Vagrantfile
$output = $cwd . DS . 'Vagrantfile';

// Check if we can actually write the file.
if (file_exists($output) && !is_writable($output)) {
    fwrite(STDERR, "ERROR: Vagrantfile cannot be written\n");
    exit(1);
}

// Helpful messaging..
fwrite(STDOUT, "Writing `{$output}`");

// Output file..
file_put_contents($output, $vagrantfile);

// Done!
fwrite(STDOUT, "\nComplete! You may now run `vagrant up` to start your instance.\n");

exit(0); // Success!
