{lib, ...}: {
  maplib = {
    filter = attrs: filterFn: let
      higherOrderFn = name: value: filterFn {inherit name value attrs;};
    in
      lib.attrsets.filterAttrs higherOrderFn attrs;
  };
}
