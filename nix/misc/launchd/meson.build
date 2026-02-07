configure_file(
  input : 'org.nixos.nix-daemon.plist.in',
  output : 'org.nixos.nix-daemon.plist',
  install : true,
  install_dir : get_option('prefix') / 'Library/LaunchDaemons',
  install_mode : 'rw-r--r--',
  configuration : {
    'storedir' : store_dir,
    'localstatedir' : localstatedir,
    'bindir' : bindir,
},
)
