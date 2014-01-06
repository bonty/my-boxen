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
  class keyremap4macbook::myconfig {
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
  }
  include keyremap4macbook::myconfig

  # iterm2
  iterm2::colors { 'my color scheme':
    ansi_0_color => [0.0, 0.0, 0.0],
    ansi_1_color => [0.13333334028720856, 0.13333334028720856, 0.89803922176361084],
    ansi_2_color => [0.17647059261798859, 0.89019608497619629, 0.65098041296005249],
    ansi_3_color => [0.11764705926179886, 0.58431375026702881, 0.98823529481887817],
    ansi_4_color => [1, 0.55294120311737061, 0.76862746477127075],
    ansi_5_color => [0.45098039507865906, 0.14509804546833038, 0.98039215803146362],
    ansi_6_color => [0.94117647409439087, 0.85098040103912354, 0.40392157435417175],
    ansi_7_color => [0.94901961088180542, 0.94901961088180542, 0.94901961088180542],
    ansi_8_color => [0.33333333333333331, 0.33333333333333331, 0.33333333333333331],
    ansi_9_color => [0.3333333432674408, 0.3333333432674408, 1],
    ansi_10_color => [0.3333333432674408, 1, 0.3333333432674408],
    ansi_11_color => [0.3333333432674408, 1, 1],
    ansi_12_color => [1, 0.3333333432674408, 0.3333333432674408],
    ansi_13_color => [1, 0.3333333432674408, 1],
    ansi_14_color => [1, 1, 0.3333333432674408],
    ansi_15_color => [1, 1, 1],
    background_color => [0.086274512112140656, 0.086274512112140656, 0.078431375324726105],
    bold_color => [1, 1, 1],
    cursor_color => [0.73333334922790527, 0.73333334922790527, 0.73333334922790527],
    cursor_text_color => [1, 1, 1],
    foreground_color => [0.73333334922790527, 0.73333334922790527, 0.73333334922790527],
    selected_text_color => [0.0, 0.0, 0.0],
    selection_color => [1, 0.8353000283241272, 0.70980000495910645],
  }

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

      # perl
      'plenv',
      'perl-build',
    ]:
  }

  # install ricty
  class ricty {
    homebrew::tap { 'sanemat/font': }
    package { 'ricty': ; }
  }
  include ricty
  exec { "cp -f ${boxen::config::homebrewdir}/Cellar/ricty/3.2.2/share/fonts/Ricty*.ttf ${home}/Library/Fonts/ && fc-cache -vf":
    require => Package['ricty'],
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
    require => [ Ruby::Gem["homesick for ${ruby_version}"], Osx_chsh[$::luser] ]
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
    # 'ATOK':
    #   source => 'http://www5.justsystem.co.jp/download/atok/ut/mac/at26try.dmg',
    #   provider => pkgdmg;
    'PCKeyboardHack':
      source => 'https://pqrs.org/macosx/keyremap4macbook/files/PCKeyboardHack-10.4.0.dmg',
      provider => pkgdmg;
    'Reflector':
      source => 'http://download.airsquirrels.com/Reflector/Mac/Reflector.dmg',
      provider => pkgdmg;
  }
}
