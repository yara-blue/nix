# Fixes mandown not downloading from comicfury
_final: prev: {
  python3Packages = prev.python3Packages.overrideScope (
    _pyfinal: pyprev: {
      mandown = pyprev.mandown.overridePythonAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ../patches/mandown.patch
        ];
      });
    }
  );
}
