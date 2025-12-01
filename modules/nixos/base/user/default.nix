{
  config,
  namespace,
  options,
  ...
}: {
  options.${namespace}.base.user = {
    inherit (options.services.getty) autologinUser;
    inherit (options.users) users;
  };
  config = {
    services.getty = {
      inherit (config.${namespace}.base.user) autologinUser;
    };
    users = {
      inherit (config.${namespace}.base.user) users;
    };
  };
}
