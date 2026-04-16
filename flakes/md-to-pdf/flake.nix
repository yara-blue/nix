# based on https://imaginarytext.ca/posts/2025/typst-templates-for-pandoc/
{
  description = "Convert a markdown file to a pdf using pandoc and typst";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
	newsreader-font.url = "path:../newsreader-font";
	newsreader-font.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
	  newsreader-font,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ newsreader-font.overlays.default ];
        };
        newsreader = pkgs.newsreader;
		fantasque = pkgs.nerd-fonts.fantasque-sans-mono;
        article_template = ./article.typ;
        review_template = ./review.typ;
        md-to-pdf = pkgs.writeShellApplication {
          name = "md-to-pdf";
          runtimeInputs = with pkgs; [
            typst
            pandoc
          ];
          text = ''
            input_path="$1"
            markdown_file="$(basename "$input_path")"
            file_name="''${markdown_file%.*}"
            pdf_file="''${file_name}.pdf"


			# Typst is really annoying and needs all files in the same dir
			dir="$(mktemp -d)"
			cp "$input_path" "$dir"
			cp ${article_template} "$dir/article.typ"
			cp ${review_template} "$dir/review.typ"

			template_arg="''${2:-}"
			case "$template_arg" in
			"")
				template="article.typ"
				;;
			"review")
				template="review.typ"
				;;
			*)
				echo 'Not a template, either pass no second argument or "review"'
				exit 64
			esac
				
			cd "$dir"

            ${pkgs.pandoc}/bin/pandoc "$markdown_file" \
              -f markdown --wrap=none \
              -t pdf --pdf-engine=${pkgs.typst}/bin/typst \
              --pdf-engine-opt=--font-path=${newsreader}/share/fonts/truetype:${fantasque}/share/fonts/truetype \
              -V template="$template" \
              -o "$pdf_file"

			cd - > /dev/null
			cp "$dir/$pdf_file" .
          '';
        };
      in
      {
        packages.default = md-to-pdf;
      }
    )
    // {
      overlays.default = _: prev: {
        md-to-pdf = self.packages.${prev.system}.default;
      };
    };
}
