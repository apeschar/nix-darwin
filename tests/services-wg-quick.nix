{ config, pkgs, ... }:

{
  networking.wg-quick.interfaces.wg0.privateKeyFile = "/var/lib/wireguard/wg0.key";

  test = ''
    plist=${config.out}/Library/LaunchDaemons/org.nixos.wg-quick-wg0.plist

    echo >&2 "checking wg-quick service in /Library/LaunchDaemons"
    grep -F "org.nixos.wg-quick-wg0" "$plist"

    echo >&2 "checking wg-quick command locking"
    script=$(awk -F'[< ]' '$6 ~ "^/nix/store/.*wg-quick-wg0" {print $6}' "$plist")
    grep -F "${pkgs.darwin.shell_cmds}/bin/lockf -k /var/run/wg-quick.lock ${pkgs.wireguard-tools}/bin/wg-quick up wg0" "$script"
  '';
}
