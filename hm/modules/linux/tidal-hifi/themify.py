import re
import argparse
import sys


def create_themed_css(css_content):
    """
    Replaces hardcoded color values in a CSS string with stylix variables.

    This function uses a predefined mapping to find and replace color codes (hex and named)
    with their corresponding Nix stylix variables (e.g., ${base00}).

    Args:
        css_content (str): A string containing the source CSS.

    Returns:
        str: The themed CSS content with stylix variables.
    """
    # This dictionary maps stylix variables to a list of colors they should replace.
    # It includes various formats (e.g., hex, named colors) for comprehensive matching.
    # This structure makes it easy to see which colors are grouped and to extend the theme.
    COLOR_MAPPING = {
        # Base Backgrounds (Lightest)
        "${base00}": [
            "#ffffff",
            "#fff",
            "#fdfdfd",
            "#fbfbfb",
            "#fcfcfc",
        ],
        # Secondary & Modal Backgrounds
        "${base01}": ["#f1f1f1", "#efefef", "#eaebeb", "#e5e5e5"],
        # Hover, Active, Disabled States
        "${base02}": ["#e7e7e8", "#00000013", "#00000017"],
        # Brighter Hover & Light Buttons
        "${base03}": [
            "#e0e2e2",
            "#d9d9d9",
            "#e0e0e0",
            "#d5d5d5",
            "#dbdbdb",
            "#0000001c",
            "#0000001a",
            "#0003",
        ],
        # UI Elements, Medium Grays, Scrollbars
        "${base04}": [
            "#bbbebe",
            "#cbcbcb",
            "#d4d4d4",
            "#c3c3c3",
            "#b6b6b6",
            "#dddde0",
            "#ababab",
            "#0000003d",
            "#a6a6a6",
        ],
        # Primary Text & Icons (Darkest)
        "${base05}": ["#000", "#000000", "#252525", "#2a2a2a", "#6e6e6e"],
        # Secondary Text
        "${base06}": [
            "#434343",
            "#383838",
            "#29292a",
            "#000000b3",
            "#000000ab",
            "#0000009a",
        ],
        # "White" Text on Colored Backgrounds
        "${base07}": ["#e6e6ed"],
        # --- Accent Colors ---
        # Red (Errors, Notifications)
        "${base08}": ["#fa5656", "#d85959", "#ff5656"],
        # Orange
        "${base09}": ["#f98f54"],
        # Yellow
        "${base0A}": ["#d1a70d", "#bc991e", "#e6d165", "#ffd332"],
        # Green
        "${base0B}": ["#356e56", "#49c47a", "#5deaa6"],
        # Cyan (Light)
        "${base0C}": ["#d5edeb"],
        # Blue / Slate
        "${base0D}": ["#96a6af", "#97a1ff"],
        # Teal / Primary Accent
        "${base0E}": ["#39afa5", "#3cb4aa", "#3bafa5", "#5ecce3", "#8bd4cf"],
        # Magenta / Pink
        "${base0F}": ["#e860d2"],
    }

    # Replace the named color 'white' and 'black' first.
    css_content = re.sub(r"\bwhite\b", "${base00}", css_content, flags=re.IGNORECASE)
    css_content = re.sub(r"\bblack\b", "${base05}", css_content, flags=re.IGNORECASE)

    # To handle box-shadows, we replace the hex color part directly.
    # We target black shadows specifically, as requested by the stylix spec (`shadow = ${base00}`).
    css_content = re.sub(
        r"(box-shadow:.*?)#000000([0-9a-fA-F]*)", r"\1${base00}\2", css_content
    )

    # Iterate through the mapping and replace each color.
    for stylix_var, color_list in COLOR_MAPPING.items():
        for color in color_list:
            try:
                # Create a regex pattern for the specific color, ignoring case.
                pattern = re.compile(re.escape(color), re.IGNORECASE)
                css_content = pattern.sub(stylix_var, css_content)
            except re.error as e:
                # This error handling is for cases where a color string might form an invalid regex.
                print(f"Regex error for color '{color}': {e}", file=sys.stderr)

    return css_content


def main():
    """
    Main function to parse arguments and run the CSS theming process.
    """
    # Set up command-line argument parsing.
    parser = argparse.ArgumentParser(
        description="Replaces hardcoded colors in a Tidal CSS file with stylix variables.",
        formatter_class=argparse.RawTextHelpFormatter,
    )
    parser.add_argument("input_file", help="The path to the source CSS file.")
    parser.add_argument(
        "-o",
        "--output",
        dest="output_file",
        help="The path to write the themed CSS file to.\nIf omitted, prints to standard output.",
    )
    args = parser.parse_args()

    # Read the source CSS from the specified input file.
    try:
        with open(args.input_file, "r", encoding="utf-8") as f:
            source_css = f.read()
    except FileNotFoundError:
        print(f"Error: Input file not found at '{args.input_file}'", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error reading input file: {e}", file=sys.stderr)
        sys.exit(1)

    # Process the CSS content to replace colors.
    themed_css = create_themed_css(source_css)

    # Write the result to the output file or print to the console.
    if args.output_file:
        try:
            with open(args.output_file, "w", encoding="utf-8") as f:
                f.write(themed_css)
            print(f"Successfully wrote themed CSS to '{args.output_file}'")
        except Exception as e:
            print(f"Error writing to output file: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        # If no output file is specified, print to standard output.
        print(themed_css)


# Execute the main function when the script is run.
if __name__ == "__main__":
    main()
