{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.tidal-hifi;
in
# TODO: add check for unfree: ++ lib.optionals osConfig.liminalOS.config.allowUnfree [ tidal-hifi ]
{
  options.programs.tidal-hifi = {
    enable = lib.mkEnableOption "tidal Hi-Fi client";
    theme = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Custom CSS to use as theme for Tidal HiFi.
      '';
    };
  };
  config = {
    home.packages = lib.mkIf cfg.enable [ pkgs.tidal-hifi ];
    xdg.configFile."tidal-hifi/themes/stylix.css".text = lib.mkIf (cfg.theme != null) cfg.theme;

    programs.tidal-hifi =
      lib.mkIf (config.liminalOS.programs.enable && osConfig.liminalOS.config.allowUnfree)
        {
          enable = true;
          theme = with config.lib.stylix.colors.withHashtag; ''
            /*
            {
              "name": "Tidal Light",
              "author": "Interstellar_1",
              "description": "A light theme for Tidal. v0.3.5b"
              "license": "MIT License"
            }
            */
            :root {
              /*background color*/
              --wave-color-solid-base-fill: ${base00} !important;
              --wave-color-solid-accent-darkest: ${base01} !important;
              --wave-color-solid-base-brighter: ${base01} !important;
              --wave-color-solid-base-bright: ${base01} !important;
              --wave-color-opacity-base-bright-thick: ${base05} !important;

              /*hover*/
              --wave-color-solid-base-brightest: ${base03} !important;
              --wave-color-opacity-base-brightest-regular: ${base01} !important;
              --wave-color-opacity-contrast-fill-regular: ${base04} !important;
              --wave-color-solid-contrast-dark: ${base03} !important;
              --transparent-play-hover: #e1e1e166 !important;

              /*border*/
              --wave-color-opacity-contrast-fill-ultra-thin: ${base02} !important;

              /*button color*/
              --wave-color-opacity-contrast-fill-thin: ${base03} !important;
              --wave-color-solid-accent-darker: ${base0C} !important;
              --wave-color-solid-rainbow-red-darkest: ${base08} !important;
              --wave-color-solid-rainbow-red-darker: ${base08} !important;
              --button-light: ${base03} !important;
              --button-medium: ${base04} !important;

              /*accents*/
              --wave-color-solid-accent-fill: ${base0E} !important;
              --text-accent: ${base0E} !important;
              [data-w="textUrl"] {
                color: var(--text-accent) !important;
              }
              --switch-accent: ${base0E} !important;
              --wave-color-solid-rainbow-yellow-fill: ${base0A} !important;

              /*primary text*/
              [data-wave-color="textDefault"] {
                color: ${base05} !important;
              }
              [data-wave-color="textWhite"] {
                color: ${base05} !important;
              }
              /*secondary text*/
              --wave-color-text-secondary: ${base06} !important;
              [data-wave-color="textSecondary"] {
                color: ${base05}000b3 !important;
              }
              --wave-color-solid-contrast-darker: ${base06} !important;
              --wave-color-opacity-contrast-fill-ultra-thick: ${base06} !important;
              /*icons*/
              --wave-color-solid-contrast-fill: ${base05} !important;
              --wave-color-opacity-contrast-fill-thick: ${base05}0009a !important;

              /*search*/
              --wave-color-opacity-base-brighter-ultra-thick: ${base04} !important;
              --search-background: ${base01}e0 !important;

              /*user profile image*/
              --user-profile-linear-gradient: linear-gradient(
                160deg,
                ${base0B} 1.22%,
                ${base0D} 40.51%,
                ${base04} 79.07%
              ) !important;
            }

            body {
              background-color: ${base00} !important;
            }
            /*GENERAL*/
            /*hide right shadow*/
            #playQueueSidebar {
              box-shadow: none !important;
            }

            /*buttons*/
            ._activeTab_f47dafa {
              background: ${base03};
            }

            /*HOMEPAGE*/
            /*artists*/
            .isLoggedIn--CEJH_::after {
              background: none;
            }

            /*hide album + playlist + mix bg*/
            ._dataContainer_66f4f40::before,
            ._dataContainer_5bb6028::before,
            ._dataContainer_7feb4a2::before {
              background-image: none;
            }

            /*artist name*/
            .css-5pl3ge {
              color: ${base05}000ab;
            }

            /*icons*/
            .icon--rmikT,
            .icon--VV33E {
              color: ${base05};
            }
            ._icon_77f3f89 {
              fill: ${base05} !important;
            }

            /*SIDEBAR*/
            ._active_3451dba:is(a._sidebarItem_730d27e, button._sidebarItem_730d27e) span {
              color: var(--wave-color-solid-accent-fill) !important;
            }

            /*player shadow*/
            .player--gAOQG.notFullscreen--xbpBL {
              box-shadow: 0 -6px 24px ${base04}26;
            }

            /*ACCENT TEXT*/
            /*yellow*/
            ._wave-badge-color-max_1oxl7_22 {
              color: ${base0A};
              background-color: ${base0A}38;
            }

            /*blue*/
            ._wave-badge-color-high_1oxl7_17 {
              color: var(--text-accent);
            }

            .wave-text-title-bold {
              color: ${base00} !important;
            }

            /*none*/
            ._wave-badge-color-default_1oxl7_7 {
              background-color: ${base03};
              color: ${base05};
            }

            svg._accentedIcon_d6d54e4 {
              color: var(--wave-color-solid-accent-fill);
              fill: var(--wave-color-solid-accent-fill) !important;
            }

            .smallHeader--rfQsR {
              --img: url(https://blocks.astratic.com/img/general-img-landscape.png) !important;
            }

            /*shortcuts*/
            ._shortcutItem_6c8e7b4 {
              box-shadow: none !important;
              background-color: var(--wave-color-solid-base-brighter) !important;
            }

            ._shortcutItem_6c8e7b4::after {
              background: linear-gradient(${base05}0, ${base00}9);
            }

            /*search*/
            .container--cl4MJ,
            div.searchField--fgDKc,
            div.searchField--fgDKc:focus,
            ._container_f1be359 {
              background-color: var(--search-background) !important;
              border-color: var(--wave-color-opacity-contrast-fill-ultra-thin) !important;
            }

            .container--sRPa5 {
              border-color: var(--wave-color-opacity-contrast-fill-ultra-thin) !important;
            }

            .icon--nNXej,
            ._icon_49dd0aa {
              background: linear-gradient(180deg, ${base00}, ${base03}) !important;
            }

            a.searchPill--ED7eQ.active--e_BIx {
              background: var(--wave-color-opacity-contrast-fill-thin) !important;
            }

            .css-10jmp6g {
              color: var(--wave-color-text-secondary) !important;
            }

            ._imageContainer_dfdf7bd::after,
            ._imageContainer_23303c1::after {
              background: var(--transparent-play-hover) !important;
            }

            /*updates*/
            .css-5pl3ge {
              color: ${base05}000ab !important;
            }

            /*explict badge*/
            ._explicitBadge_b93510b {
              filter: invert(40%) brightness(110%) contrast(140%);
            }

            #explicit-badge {
              color: ${base05} !important;
            }

            /*video badge*/
            .videoBadge--Tpdav {
              fill: var(--wave-color-text-secondary);
              filter: brightness(0.3) invert(0);
            }

            /*canvas nav buttons*/
            .viewAllButton--Nb87U,
            .css-7l8ggf {
              background: ${base03};
            }

            .viewAllButton--Nb87U:hover,
            .css-7l8ggf:hover {
              background: ${base04};
            }

            /*album hover*/
            .overlay--ces1Z,
            .overlay--Dn4ax,
            .overlay--Cb6su,
            .css-17bbmu3,
            .css-ohr3gy,
            ._overlay_3c15650,
            ._overlay_aa1ee83,
            ._overlay_62e2cfd,
            ._overlay_e0e48ef,
            ._overlay_7fd73e6,
            ._overlay_f627136,
            .css-1ug9uri,
            .css-u7yq00 {
              background: linear-gradient(${base05}0, ${base00}9e) !important;
            }

            :is(._dataContainer_66f4f40 ._coverArtContainer_2eafdf9)
              ._creditsOverlay_b234d8c {
              background: ${base00}80;
            }

            /*artist hover*/
            .css-179fhoi,
            .css-fvlky0 {
              background: linear-gradient(${base05}0, ${base00}9e) !important;
            }

            /*play button hover*/
            .css-75d7zy {
              background-color: ${base00}a6;
              transition: 100ms;
            }

            .css-75d7zy:hover {
              background-color: var(--wave-color-solid-base-brighter);
            }

            button.button--W_J5g.gray--tvcIF.contextMenuButton--Bcnyd:hover {
              background-size: 200%;
            }

            /*playlist hover*/
            .css-1voubjj:hover {
              background-color: var(--wave-color-solid-base-brighter);
              border: 5px var(--wave-color-opacity-contrast-fill-ultra-thin);
            }

            /*queue popup*/
            .bottomGradient--BngZe,
            ._bottomGradient_104d99b {
              background-image: none;
            }

            #playQueueSidebar {
              box-shadow: 0 20px 25px 5px ${base00}57;
            }

            /*audio quality popup*/
            ._containerMax_611862e {
              background-color: transparent;
            }

            /*PLAYER PANE*/
            .range--JNSfg {
              background-color: ${base04};
            }

            :is(._player_1d16b04 button).withBackground[aria-checked="true"] {
              background-color: ${base02};
            }

            ._range_ce0e571 {
              background-color: var(--wave-color-opacity-contrast-fill-regular);
            }

            /*album hover*/
            ._notFullscreenOverlay_1442d60 {
              background: linear-gradient(0deg, ${base00}a6, ${base00}a6);
            }

            /*FULL VIEW*/
            .activeTab--bqTiv {
              background: ${base02};
            }

            .container--cl4MJ {
              background: ${base00}63 !important;
            }

            .css-u7yq00 {
              background: ${base00}75;
            }

            ._bottomGradient_5c344de {
              background: none;
            }

            ._button_84b8ffe {
              background-color: var(--wave-color-solid-base-brighter);
            }

            ._button_84b8ffe:hover {
              background-color: var(--wave-color-solid-base-brightest);
            }

            ._baseButton_15fc215:focus {
              background: ${base03};
            }

            #nowPlaying {
              background-image: none !important;
            }

            /*thumbnail*/
            ._albumImageOverlay_2eabc2b {
              background: ${base00}4f;
            }

            /*ALBUM*/
            .albumImage--i2CqD {
              box-shadow:
                0 20px 50px 5px ${base04}38,
                0 20px 40px 0 ${base05}00024;
            }

            ._button_f1c7fcb {
              background: var(--wave-color-solid-base-brighter);
            }

            .artist-link {
              color: ${base05};
            }

            /*remove bg image*/
            [class^="_dataContainer_"]:before {
              --img: none !important;
              background-image: none !important;
            }

            /*playlist*/
            .refreshButton--bRrPi {
              color: ${base05};
            }

            /*tracks page*/
            .variantPrimary--pjymy,
            ._button_3357ce6 {
              background-color: var(--button-light);
            }

            .wave-text-body-demi {
              color: ${base05};
            }

            /*track hover*/
            ._rowContainer_ebb4cfc:hover {
              background: var(--wave-color-solid-base-brightest) !important;
            }

            /*DIALOUGES*/
            .ReactModal__Content {
              background: ${base01} !important;
            }

            .label--fycqD.unchecked--goEjz {
              background-color: ${base04};
            }

            .label--fycqD.checked--RVmZV {
              background-color: var(--switch-accent);
            }

            .primary--NLSX4 {
              background-color: ${base03};
            }

            .primary--NLSX4:hover {
              background-color: var(--wave-color-opacity-contrast-fill-regular) !important;
            }

            .primary--NLSX4:disabled {
              background-color: ${base02};
            }

            .primary--NLSX4:disabled:hover {
              background-color: ${base02};
            }

            /*popups*/
            .notification--hckxF,
            .native-range {
              box-shadow: 0 20px 50px 5px ${base00}2e;
            }

            ._notification_99c9c6e {
              box-shadow: 0 16px 32px ${base05}0;
            }

            ._notification_99c9c6e._error_0b778e5 {
              background: var(--wave-color-solid-rainbow-red-darker);
            }

            .errorIcon--VvndK {
              fill: ${base05} !important;
            }

            /*PROFILE*/
            .followingTag--CKRME,
            .wave-text-footnote-medium {
              color: var(--text-accent) !important;
            }

            ._wave-btn-rank-primary_1lao2_58:hover {
              background-color: ${base0E};
            }

            ._button_94c5125 {
              background-color: transparent !important;
            }

            .profilePicture--yrdRB {
              box-shadow: none;
            }

            ._input_15c0d78:focus {
              color: var(--wave-color-solid-contrast-darker);
            }

            /*my picks*/
            #My\ favorite\ track\ on\ repeat,
            ._selectedPrompt_dac4cfc[style*="--prompt-base-color: ${base0D}1A"] {
              --prompt-base-color: ${base0D} !important;
              --prompt-color: ${base0E} !important;
            }

            #My\ major\ mood\ booster,
            ._selectedPrompt_dac4cfc[style*="--prompt-base-color: #FF91531A"] {
              --prompt-base-color: ${base09} !important;
              --prompt-color: ${base0A} !important;
            }

            #My\ go-to\ artist\ right\ now,
            ._selectedPrompt_dac4cfc[style*="--prompt-base-color: #FF53531A"] {
              --prompt-base-color: ${base08} !important;
              --prompt-color: ${base0F} !important;
            }

            #My\ top\ album\ recently,
            ._selectedPrompt_dac4cfc[style*="--prompt-base-color: #53FF981A"] {
              --prompt-base-color: ${base0B} !important;
              --prompt-color: ${base0B} !important;
            }

            ._wave-btn-rank-clean_1lao2_127:hover {
              color: ${base00};
              background-color: ${base05}38 !important;
            }

            #pick-promt-item-search-field {
              color: ${base05};
            }

            /*ARTIST PAGE*/
            ._background_4a10ea2:after {
              content: "" !important;
              position: absolute !important;
              top: 0 !important;
              left: 0 !important;
              right: 0 !important;
              bottom: 0 !important;
              background-color: ${base00}4a !important;
            }

            :is(._background_a548b6d ._image_7ba9b97):before {
              background-color: ${base00}21 !important;
              background-image: none !important;
              background-blend-mode: normal !important;
            }

            ._background_a548b6d {
              background-image: linear-gradient(180deg, ${base00}66 0, ${base00}) !important;
            }

            :is(._background_a548b6d ._image_7ba9b97):after {
              background-image: var(--img) !important;
              background-position: center !important;
              background-repeat: no-repeat !important;
              background-size: cover !important;
              content: "" !important;
              filter: blur(5px) brightness(30%) !important;
              inset: -20px 0 !important;
              mask-image: linear-gradient(0deg, ${base00}0 43%, ${base00}) !important;
              position: absolute !important;
            }

            ._mainImage_433f1ff:is(._background_a548b6d ._image_7ba9b97):after {
              mask-image: linear-gradient(0deg, ${base00}0, ${base00}) !important;
              filter: brightness(100%) !important;
              height: 87% !important;
            }

            .buttonText--LMsAT {
              color: ${base00} !important;
            }

            .css-10jmp6g {
              color: ${base05};
            }

            .button--_0I_t {
              background-color: var(--button-light);
            }

            .button--_0I_t:hover {
              background-color: var(--wave-color-opacity-contrast-fill-regular);
            }

            #player__play {
              color: ${base05};
            }

            .primary--NLSX4:hover {
              background-color: ${base04};
            }

            :is(._buttons_ff12873 ._following_657edad) ._icon_29252d0 {
              fill: var(--wave-color-solid-accent-fill) !important;
            }

            /*bio*/
            ._dialog_148b5df {
              color: ${base05};
            }

            /*producer discography*/
            .css-1thhtwd {
              background: var(--wave-color-solid-base-brighter);
            }

            .css-1thhtwd:hover {
              background: var(--wave-color-opacity-contrast-fill-regular);
            }

            ._buttonActive_5125b72 {
              background: var(--button-light);
            }

            ._buttonActive_5125b72:hover {
              background: var(--wave-color-opacity-contrast-fill-regular);
            }

            ._buttonActive_5125b72 > .wave-text-body-medium {
              color: ${base05};
            }
            /*SETTINGS*/
            ._container_b4f1e20._fillDark_a1e5896 > div,
            ._container_9a0abb9 {
              background: ${base01} !important;
            }

            ._select_ef84104 {
              background: var(--wave-color-solid-accent-darker) !important;
            }

            .licenseFrame--C_hup {
              background: ${base06};
            }

            svg#lastfm path {
              fill: ${base05};
            }

            ._button_94c5125 {
              background: var(--wave-color-solid-base-brighter);
            }

            /*scrollbars*/
            ::-webkit-scrollbar {
              background-color: transparent !important;
              border: none !important;
              width: 8px !important;
            }

            ::-webkit-scrollbar-track {
              background-color: var(--wave-color-solid-base-brighter) !important;
              box-shadow: none;
            }

            ::-webkit-scrollbar-thumb {
              background-color: ${base04} !important;
              border: none !important;
            }

            /*luna*/
            body
              > div.ReactModalPortal
              > div
              > div
              > div.modalBody--TFBWU.selectableText--UDUkZ.modalText--gCapb.subtitle--dYfEG
              > neptune-reactive-root
              > div
              > button,
            #main
              > div.__NEPTUNE_PAGE
              > neptune-reactive-root
              > div
              > div
              > div:nth-child(2)
              > div
              > div.neptune-card
              > div
              > div:nth-child(2)
              > div:nth-child(1)
              > button:nth-child(1),
            #main
              > div.__NEPTUNE_PAGE
              > neptune-reactive-root
              > div
              > div
              > div:nth-child(2)
              > div
              > div.neptune-card
              > div
              > div:nth-child(2)
              > div:nth-child(1)
              > button:nth-child(2) {
              color: ${base05} !important;
            }

            .neptune-switch::after {
              background-color: ${base00} !important;
            }

            .css-16hze37,
            #main
              > div:nth-child(3)
              > div
              > div.MuiContainer-root.MuiContainer-maxWidthLg.css-sot3eg
              > div
              > div:nth-child(2)
              > div.MuiStack-root.css-16a8gxx
              > div {
              color: ${base07} !important;
            }

            .css-yc8597,
            .css-pfqxe1,
            .css-axw7ok {
              color: ${base00} !important;
            }

            to {
              opacity: 1;
              transform: scale(1);
            }
          '';
        };
  };
}
