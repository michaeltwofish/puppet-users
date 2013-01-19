define users::account(
	$ensure=present, $managehome='true', $allowdupe='false', $homeprefix='/home',
	$username, $name, $uid, $gid=undef, $groups=[],
	$key='', $keytype='ssh-rsa', $shell='/bin/zsh') {

	if $ensure == absent and $username == 'root' {
		fail('Will not delete root user')
	}
	# If default group isn't passed, assume we're using UPG and create the
	# user's group, otherwise require the group
	if $gid == undef {
		group { $username:
			ensure => present;
		}
		$gid_real = $username
	} else {
		$gid_real = $gid
	}
	File { owner => $username, group => $gid_real, mode => '0600' }

	$home = "${homeprefix}/${username}"
	if $username == 'root' {
		$home = '/root'
	}

	user { $username:
		ensure     => $ensure,
		uid        => $uid,
		gid        => $gid_real,
		comment    => "$name",
		groups     => $groups,
		shell      => "$shell",
		home       => $home,
		require    => Group[$gid_real],
		allowdupe  => $allowdupe,
		managehome => $managehome;
	}

	case $ensure {
		present: {
			file { $home:
				ensure => directory
			}
			if $key {
				file { "$home/.ssh":
				    ensure => directory;
				}
				ssh_authorized_key { $username:
				  user    => $username,
				  require => File["$home/.ssh"],
				  key     => $key,
				  type    => $keytype,
				  ensure  => $ensure;
				}
			}
		}
		absent: {
			file { $home:
				ensure  => $ensure,
				force   => true,
				recurse => true,
			}
			if ( $gid_real == $username ) {
				group { $gid_real:
					ensure => $ensure;
				}
			}
		}
	}
}
