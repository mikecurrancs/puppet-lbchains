class lbchains (
  $voice_port = $lbchains::params::voice_port,
  $https_port = $lbchains::params::https_port,
  $https_forward_port = $lbchains::params::https_forward_port,
  $http_port = $lbchains::params::http_port,
  $http_forward_port = $lbchains::params::http_forward_port,
) inherits params::pp {
}
