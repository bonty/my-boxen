class people::bonty {
  include alfred
  include appcleaner
  include chrome
  include chrome::canary
  include dropbox
  include better_touch_tools
  include firefox
  include keyremap4macbook
  include java
  include iterm2::stable
  include istatmenus4
  include hipchat
  include onyx
  include sourcetree
  include skype
  include sequel_pro
  include virtualbox
  include vagrant

  # osx
  include osx::global::enable_keyboard_control_access
  include osx::global::disable_autocorrect
  include osx::dock::autohide
  include osx::finder::unhide_library
  include osx::finder::show_hidden_files
  class osx::show_all_extensions {
    boxen::osx_defaults  { 'Show all extensions':
      ensure => present,
      user => $::boxen_user,
      domain => 'NSGlobalDomain',
      key => 'AppleShowAllExtensions',
      value => true;
    }
  }
  include osx::show_all_extensions
  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  class osx::disable_dashboard {
    include osx::dock
    boxen::osx_defaults { 'Disable dashboard':
      ensure => present,
      user => $::boxen_user,
      domain => 'com.apple.dashboard',
      key => 'mcx-disabled',
      value => true;
    }
  }
  include osx::disable_dashboard

  # keyremap4macbook
  include keyremap4macbook::login_item
  keyremap4macbook::remap { 'space2shiftL_space_fnspace': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlD': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlH': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlI': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlLeftbracket': }
  keyremap4macbook::remap { 'controlJ2enter': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlM': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlV': }
  keyremap4macbook::cli { 'enable option.emacsmode_commandV': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlY': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlAE': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlK': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlW': }
  keyremap4macbook::cli { 'enable option.emacsmode_OptionWCopy': }
  keyremap4macbook::cli { 'enable option.emacsmode_optionLtGt': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlSlash': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlS': }
  keyremap4macbook::cli { 'enable option.emacsmode_ex_commandW': }
  keyremap4macbook::remap { 'app_term_commandL2optionL_except_tab': }
  keyremap4macbook::remap { 'jis_unify_kana_eisuu_to_commandR': }

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
      'ec2-ami-tools',
      'ec2-api-tools',
      'elb-tools',
      'rds-command-line-tools',
    ]:
  }

  # emacs
  package {
    'emacs':
      install_options => [
        '--cocoa',
        '--srgb',
        '--japanese',
        '--use-git-head',
      ];
  }

  file { '/Applications/Emacs.app':
    ensure => directory,
    recurse => true,
    source => '/opt/boxen/homebrew/opt/emacs/Emacs.app',
    require => Package['emacs']
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

  package {
    'Elasticfox-ec2tag':
      source => 'https://s3-ap-northeast-1.amazonaws.com/elasticfox-ec2tag/Elasticfox-ec2tag_app-0.4.4.1.dmg',
      provider => pkgdmg;
    'GraffitiPot':
      source => 'http://crystaly.com/graffitipot/GraffitiPot_1.1.zip',
      provider => compressed_app;
    'GoogleJapaneseInput':
      source => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
      provider => pkgdmg;
    'Bartender':
      source => 'http://www.macbartender.com/Demo/Bartender.zip',
      provider => compressed_app;
    'PCKeyboardHack':
      source => 'https://pqrs.org/macosx/keyremap4macbook/files/PCKeyboardHack-10.4.0.dmg',
      provider => pkgdmg;
  }
}
