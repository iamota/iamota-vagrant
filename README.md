# Vagrant Local Development Environment

This project provides a standardized a local development environment using [Vagrant](http://vagrantup.com), provisioned by [Chef Solo](vagrantup.com/docs/provisioning/chef_solo.html), running inside Virtualbox machines.

[Vagrant Manager](http://vagrantmanager.com/) is a cross-platform app that helps simplfy management of the (many) vagrant boxes you will have installed on your system.

If you are troubleshooting, see the notes at the bottom of the readme.

## Setting up an existing project

There are just a handful of steps:

1. Ensure the pre-requisite software is installed:

   [Vagrant](https://www.vagrantup.com/downloads.html), [Virtualbox](https://www.virtualbox.org/wiki/Downloads), [Chef Client](https://downloads.chef.io), [Composer](https://getcomposer.org), [NPM](https://nodejs.org/en/download/), [Bower](https://bower.io)

2. Clone the **project repository** into a directory on your machine. (Note: You probably don't want to clone THIS repository).

3. Run the following commands:

		npm install
		bower install
		composer install
		php .local/setup-vagrant.php
		grunt prod

### Generate your Vagrantfile

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
	Output path: /Users/your/awesome-project/Vagrantfile
	Complete! You may now run `vagrant up` to start your instance.

Once you've completed the Vagrantfile generation, you can set up your vagrant instance by running `vagrant up`.

***Done configuring your environment. You can stop here.***

----

## New setup of local dev environment

If you are setting up a **brand new environment**, follow these steps below.

**Step 1:** Add/modify `composer.json` file to contain the following:

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

**Step 2:** Add a file named `vagrant.json` to your project with the following format:

	{
		"http_port": "8080",
		"mage_port": "8081",
		"extra_recipes": ""
	}

vagrant.json options:

`http_port` : Modify to reflect port assigned to the project. Assignments are recorded on Google Drive in the [Project Port Assignment spreadsheet](https://docs.google.com/a/iamota.com/spreadsheets/d/1pFm1RVFnsfQsNyC2YpmfQZtubdgDO7mOfymduogZDRA/edit?usp=sharing).

`extra_recipes` : A list of additional Chef recipes that must be parsed by Chef during provisioning.

**Step 3:** Modify the `.gitignore` file to include the following definition:

	.local/

***New environment setup complete!***


## Notes

If a vagrant.json exists in this repository, it's meant for testing. It is not meant to be deployed into a project, but used for reference when creating the vagrant.json for your specific project.

When working on the iamota-vagrant project, you will get errors when running `php setup-vagrant.php` unless you symlink the project "root" directory as a sub-directory named `.local`. Do this by running the following command: `ln -s . .local`


