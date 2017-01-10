# Vagrant Local Development Environment

Standardized local development environment using Vagrant.

## Installing the local environment

**Step 1:** Modify your `composer.json` to add the following:

Under `repositories` section, add:

    {
        "type": "vcs",
	"url": "git@github.com:iamota/iamota-vagrant.git"
    }

Under the `require` section:

    "oomphinc/composer-installers-extender": "1.1.1"

Under the `require-dev` section:

    "iamota/iamota-vagrant": "1.x"

Under the `extras` section, modify to reflect the following:

    "extra": {
        "installer-types": ["local-dev-environment"],
        "installer-paths": {
            ".local/": ["type:local-dev-environment"]
        }
    }


## Setting up the project Vagrant box

**Step 2:** Add a file named `vagrant.json` to your project with the following format:

    {
	    "http_port": "8080",
	    "extra_recipes": "localdev::geoip localdev::something-else"
    }

Configuration options:

`http_port` : Modify to reflect port assigned to the project. Assignments are recorded on Google Drive in the [Project Port Assignment spreadsheet](https://docs.google.com/a/iamota.com/spreadsheets/d/1pFm1RVFnsfQsNyC2YpmfQZtubdgDO7mOfymduogZDRA/edit?usp=sharing).

`extra_recipes` : A list of additional Chef recipes that must be parsed by Chef during provisioning.

## Configure gitignore

**Step 3:** Modify the `.gitignore` file to include the following definition:

    .local/

## Generate your Vagrantfile

From the project root directory, run the following command:

    $ php .local/setup-vagrant.php

Follow the prompts to generate your Vagrantfile.

	Configuring your Vagrant instance. Hit enter to use [default] value.

	Project root dir [.]:
	Project HTTP Port [8085]:
	HTTP Hostname [localhost]:
	MySQL Port [3306]:
	Virtual Box Guest Memory [1024]:
	Virtual Box Guest CPUs [1]:

	New Vagrantfile
	========================================

	[--snip!---]

	========================================

	Generating Vagrantfile...
	Output path: /Users/mike/code/iamota-components/Vagrantfile
	Complete! You may now run `vagrant up` to start your instance.

Once you've completed the Vagrantfile generation, you can set up your vagrant instance by running `vagrant up`.

***Done***
