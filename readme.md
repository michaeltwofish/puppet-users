## What is Puppet Users?

How do I manage users with [Puppet](http://puppetlabs.com/puppet/what-is-puppet/)? The question gets asked a lot and the most common answer is something like, use LDAP. But the reality is that LDAP isn't appropriate for all user cases: maybe you just have a user or two, or you just want to a way to easily change the [Vagrant](http://www.vagrantup.com/) user's shell. That's what this module is for.

## How do I use it?

Add a `people.pp` that's something like this:

```
class users::people {
	@users::account {
		"vagrant":
			username => "vagrant",
			name     => "vagrant",
			uid      => 1000,
			shell    => '/bin/zsh'
	}
}
```

In your site manifest, you can now realize the user.

```
include users
Users::Account <| title == vagrant |>
```

## What parameters can I use?

You can use a subset of the parameters used in the [Puppet user resource type](http://docs.puppetlabs.com/references/latest/type.html#user), basically the ones that I use.

* `ensure`: The state of the user. Valid values are `present` and `absent`, and the default is `present`.
* `managehome`: Whether to manage the user's home directory. Defaults to `true`, which is the opposite of Puppet's default, because that suits me.
* `allowdupe`: Whether to allow duplicate UIDs. Defaults to `false`.
* `homeprefix`: Where to create the user's home account. Defaults to `/home`.
* `username`: The user's username.
* `name`: The user's real name.
* `uid`: A numerical UID for the user.
* `gid`: The user's primary group, either numerically or by name. If undefined, it's assumed that [User Private Groups](https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/3/html/Reference_Guide/s1-users-groups-private-groups.html) are being used, so a group with the user's username will be created.
* `groups`: An array of other groups the user should be assigned to. It's your responsibility to ensure the groups exist.
* `key`: An ssh key to be used for authentication, created using the [Puppet SSH authorized key resource type](http://docs.puppetlabs.com/references/latest/type.html#sshauthorizedkey).
* `keytype`: The type of ssh key. Defaults to `ssh-rsa`.
* `shell`: The user's shell. Defaults to `/bin/zsh`, because that makes me happy.

## This is terrible! Or even, how can I help?

Pull requests, issues or advice are very (very!) welcome.

## To do

* Write tests and test across platforms.
* Manage passwords without clobbering ones that have been changed by the user.

## Inspiration
http://itand.me/using-puppet-to-manage-users-passwords-and-ss
