{
  nix.settings = {
    extra-substituters = [
      "https://aleks-nixos-cache.cachix.org"
    ];
    extra-trusted-public-keys = [
      "aleks-nixos-cache.cachix.org-1:dUUzYdPCHmx9EH6zYdnQV+h7sNysvU9xhzXKKMGhP10="
    ];
  };
}
