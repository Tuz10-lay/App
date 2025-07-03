{ pkgs, lib, config, inputs, ... }:

{

  # Android development
  android = {
    enable = true;
    # jdk.package = pkgs.jdk21;
    flutter.enable = true;
    platforms.version = [ "32" "33" "34" ];
    systemImageTypes = [ "google_apis_playstore"];
    abis = [ "arm64-v8a" "x86_64" ];
    cmake.version = [ "3.22.1" ];
    cmdLineTools.version = "11.0";
    tools.version = "26.1.1";
    platformTools.version = "34.0.5";
    buildTools.version = [
      "30.0.3"
      "33.0.1"
    ];
    emulator = {
      enable = true;
      version = "34.1.9";
    };
    sources.enable = false;
    systemImages.enable = true;
    ndk.enable = true;
    googleAPIs.enable = true;
    googleTVAddOns.enable = true;
    extras = [ "extras;google;gcm" ];
    extraLicenses = [
      "android-sdk-preview-license"
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
    # android-studio = {
    #   enable = true;
    #   package = pkgs.android-studio;
    # };
  };






  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.vscodium
    pkgs.libsecret
    pkgs.google-chrome
    pkgs.chromium
    pkgs.glibc
    pkgs.xdg-utils 
    pkgs.bash
    # pkgs.jdk21
  ];

  env = {
    # CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome"; # failed
    # CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/chromium"; # failed
    GREET = "devenv";
    CHROME_EXECUTABLE = lib.getExe pkgs.google-chrome; # this solve the chrome executable problem
    # JAVA_HOME = lib.mkForce "${pkgs.jdk21}/lib/openjdk";
    FLUTTER_WEB_BROWSER = "firefox";
    
  };

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    hello
    git --version
    flutter --version
    dart --version
    java --version
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
