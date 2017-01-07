# Vagrant Local Development Environment

Standardized local development environment using Vagrant.

## Configuring a new project

**Step 1:** Modify your `composer.json` to add the following:

Under `repositories` section, add:

    {
        "type": "vcs",
		"url": "git@github.com:iamota/iamota-vagrant.git"
    },

Under the `require` (_or possibly `require-dev`_) section:

    "oomphinc/composer-installers-extender": "1.1.1",
    "iamota/iamota-vagrant": "1.x",

Under the `extras` section, modify to reflect the following:

    "extra": {
        "installer-types": ["local-dev-environment"],
        "installer-paths": {
            ".local/": ["type:local-dev-environment"]
        }
    }

**Step 2:** Add a file named `vagrant.json` to your project. See below for formatting.


    {
	    "http_port": "8080",
	    "extra_recipes": "localdev::geoip localdev::something-else"
    }

**Important Note:** You _must_ modify the `http_port` to reflect the port assigned to the project. Project port assignments are cataloged on Google Drive:

