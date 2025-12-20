# Vodrech Neovim Setup

## Setup

Current nvim setup is using a 'user-based' setup which means you put a folder in the `/lua` which represents a user `which mine is vodrech :-)`. This is for easier managing of users and their configurations, even tho in most cases you will just have one.

## Sourcing of User Configurations

In the `/lua/vodrech/init.lua` you can find all sourcing of the config for the user.
Here you define global settings, plugin manager configs etc.

```
Note: Remember that the order matters of the sourcing eg:

    require("usr.prerequisites") -- This get sourced first
    reqiure("usr.plugin") -- This get sourced second

```

### Prerequisites

This is just for setting up neovim on a new machine and get information on what is neccessary to have for this configurations to work.
