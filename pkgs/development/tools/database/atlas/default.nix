{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "atlas";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    rev = "v${version}";
    hash = "sha256-mnLrmsKFDpjTHyOgOeL/YsWcTfbKgv/M+phJSMFQReU=";
  };

  modRoot = "cmd/atlas";

  vendorHash = "sha256-Xi0N3lU/gqmkqJcJeQqkKr0rcbad6cIclhq4t6DCTZI=";

  nativeBuildInputs = [ installShellFiles ];

  env.GOWORK = "off";

  ldflags = [ "-s" "-w" "-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v${version}" ];

  subPackages = [ "." ];

  postInstall = ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  meta = with lib; {
    description = "A modern tool for managing database schemas";
    homepage = "https://atlasgo.io/";
    changelog = "https://github.com/ariga/atlas/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    mainProgram = "atlas";
  };
}
