class people::bonty {
  $home = "/Users/${::luser}"

  # homebrew
  package {
    [
      'git-flow',
      'lv',
      'memcached',
      'mercurial',
      'mysql',
      'redis',
      'source-highlight',
      'sqlcipher',
      'tig',
      'tmux',
      'tree',
      'wget',
    ]:
  }

  # zsh
  package {
    'zsh':
      install_options => [
        '--disable-etcdir',
      ];
  }

  file_line { 'add zsh to /etc/shells':
    path => '/etc/shells',
    line => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
    before => Osx_chsh[$::luser];
  }

  osx_chsh { $::luser:
    shell => "${boxen::config::homebrewdir}/bin/zsh";
  }

  # ruby
  $ruby_version = '2.0.0'
  class { 'ruby::global':
    version => $ruby_version
  }

  ruby::gem { "homesick for ${ruby_version}":
    gem => 'homesick',
    ruby => $ruby_version
  }
  exec { 'apply homesick':
    command => "env -i zsh -c 'source /opt/boxen/env.sh && RBENV_VERSION=${ruby_version} homesick clone bonty/dotfiles && RBENV_VERSION=${ruby_version} homesick pull dotfiles && yes | RBENV_VERSION=${ruby_version} homesick symlink dotfiles'",
    provider => 'shell',
    cwd => $home,
    require => [ Ruby::Gem["homesick for ${ruby_version}"], Package['zsh'] ]
  }

  # mysql
  file { "${home}/Library/LaunchAgents/homebrew.mxcl.mysql.plist":
    ensure => 'link',
    target => '/opt/boxen/homebrew/opt/mysql/homebrew.mxcl.mysql.plist',
    require => Package['mysql'],
  }
  exec { "launch mysql on start":
    command => "launchctl load -w ${home}/Library/LaunchAgents/homebrew.mxcl.mysql.plist",
    path => "/bin/",
    require => File["${home}/Library/LaunchAgents/homebrew.mxcl.mysql.plist"],
  }

  # redis
  file { "${home}/Library/LaunchAgents/homebrew.mxcl.redis.plist":
    ensure => 'link',
    target => '/opt/boxen/homebrew/opt/redis/homebrew.mxcl.redis.plist',
    require => Package['redis'],
  }
  exec { "launch redis on start":
    command => "launchctl load -w ${home}/Library/LaunchAgents/homebrew.mxcl.redis.plist",
    path => "/bin/",
    require => File["${home}/Library/LaunchAgents/homebrew.mxcl.redis.plist"],
  }

  # memcached
  file { "${home}/Library/LaunchAgents/homebrew.mxcl.memcached.plist":
    ensure => 'link',
    target => '/opt/boxen/homebrew/opt/memcached/homebrew.mxcl.memcached.plist',
    require => Package['memcached'],
  }
  exec { "launch memcached on start":
    command => "launchctl load -w ${home}/Library/LaunchAgents/homebrew.mxcl.memcached.plist",
    path => "/bin/",
    require => File["${home}/Library/LaunchAgents/homebrew.mxcl.memcached.plist"],
  }
}
