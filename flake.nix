{
  description = "Terraform and Terragrunt development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShells."${system}".default =
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            terraform
            terragrunt
            awscli2
            jq
          ];

          shellHook = ''
            export TG_PROVIDER_CACHE=1
            export AWS_PROFILE=demo-profile
            export AWS_REGION=eu-central-1

            echo "Welcome to the Terraform + Terragrunt development environment!"

            echo "Terraform Version:"
            terraform --version

            echo "Terragrunt Version:"
            terragrunt --version

            exec ${pkgs.zsh}/bin/zsh
          '';
        };
    };
}
