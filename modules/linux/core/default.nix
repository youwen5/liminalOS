{
  security.sudo.enable = false;

  security.doas = {
    enable = true;
    extraRules = [
      {
        keepEnv = true;
        persist = true;
      }
    ];
  };
}
