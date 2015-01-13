# Call this class in a profile with:
# class lbchains {'new_lbchain_class':
#  port => '8080',
# }
#

class lbchains (
  $port = $lbchains::params::port, # Default to the port setting in params or override here
  
) inherits lbchains::params {


  # Then use the init to parse the lbchains:voice or set ordering for other classes
  class lbchains::voice { 'new_voice_class_instanciation':
    port => $port,
  }
  # -> # This sets an explicit ordering dependency, everything after the '->' gets ran after the lbchains::voice class
  # class some_other_class {'other_class': }...
}
