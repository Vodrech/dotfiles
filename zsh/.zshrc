# [Bring your tool kit like a turtle bring its shell]
#                     __
#          .,-;-;-,. /'_\
#        _/_/_/_|_\_\) /
#      '-<_><_><_><_>=/\
#        `/_/====/_/-'\_\
#         ""     ""    ""
# ZSHRC Configurations Vodrech

# Global Variables
export CONFIG_HOME="$HOME/.config/zsh" # Current location
export PROPERTIES_HOME="$HOME/.properties" # Property files
export DEVELOPMENT_HOME="$HOME/development" # All development projects
export TEST_HOME="$HOME/test" # Test area

# Inital
echo " Source: $HOME/.config/zsh/.zshrc" | tee /tmp/zsh.log # Do not append
echo " Shell: $SHELL" | tee -a /tmp/zsh.log

# Loading of modules
if [ -f $CONFIG_HOME/.module_profile ]; then
	source $CONFIG_HOME/.module_profile
else
	echo " Modules: -"
fi

# ---------------------------------------------------------------------------
