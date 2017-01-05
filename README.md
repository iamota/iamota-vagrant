# Vagrant

## Adding Vagrant to a project

Step 1:
Add this project to your `composer.json` file under `require-dev` section.

Step 2:
Add a file named `vagrant.json` to your project. See below for formatting.

## Configuring Vagrant



## iamota.json format
```
{
	"name": "localdev",
	"vagrantfile": {
		"http_port": "8080"
	},
	"extra_recipes": [
	]
}
```
