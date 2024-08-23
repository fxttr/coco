{ config, lib, pkgs, ... }:

with lib;

let
  wallpaper = cfg.wallpaper;
  colorscheme = import ./../../colors.nix;
  fontConf = {
    names = [ "Source Code Pro" ];
    size = 11.0;
  };
  extra = ''
    set +x
    ${pkgs.util-linux}/bin/setterm -blank 0 -powersave off -powerdown 0
    ${pkgs.xorg.xset}/bin/xset s off
    ${pkgs.xcape}/bin/xcape -e "Hyper_L=Tab;Hyper_R=backslash"
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option ctrl:nocaps
  '';

  hdmiExtra = ''
    ${pkgs.xorg.xrandr}/bin/xrandr xrandr --output HDMI-0 --primary --mode 1920 x1080 --pos 0 x0 --rotate normal --output DP-0 --off --output DP-1 --mode 1920 x1080 --pos 1920 x0 --rotate normal --output DP-2 --off --output DP-3 --off --output DP-4 --off --output DP-5 --off
  '';

  cfg = config.coco.xmonad;
in
{
  options.coco.xmonad.enable = mkEnableOption "Install xmonad";

  config = mkIf cfg.enable
    {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            monitor = 0;
            follow = "mouse";
            geometry = "300x60-15+46";
            indicate_hidden = "yes";
            shrink = "yes";
            transparency = 0;
            notification_height = 0;
            separator_height = 2;
            padding = 8;
            horizontal_padding = 8;
            frame_width = 3;
            frame_color = "#000000";
            separator_color = "frame";
            sort = "yes";
            idle_threshold = 120;
            font = "Source Code Pro1 12";
            line_height = 0;
            markup = "full";
            format = "<b>%s</b>\n%b";
            alignment = "left";
            show_age_threshold = 60;
            word_wrap = "yes";
            ellipsize = "middle";
            ignore_newline = "no";
            stack_duplicates = true;
            hide_duplicate_count = false;
            show_indicators = "yes";
            icon_position = "left";
            max_icon_size = 32;
            sticky_history = "yes";
            history_length = 20;
            title = "Dunst";
            class = "Dunst";
            startup_notification = false;
            verbosity = "mesg";
            corner_radius = 8;
            mouse_left_click = "close_current";
            mouse_middle_click = "do_action";
            mouse_right_click = "close_all";
          };

          urgency_low = {
            foreground = "#ffd5cd";
            background = "#121212";
            frame_color = "#181A20";
            timeout = 10;
          };

          urgency_normal = {
            background = "#121212";
            foreground = "#ffd5cd";
            frame_color = "#181A20";
            timeout = 10;
          };

          urgency_critical = {
            background = "#121212";
            foreground = "#ffd5cd";
            frame_color = "#181A20";
            timeout = 0;
          };
        };
      };

      home.packages = [
        pkgs.feh
        pkgs.ranger
        pkgs.dmenu
      ];

      programs.alacritty = {
        enable = true;
        settings = {
          colors.primary = {
            background = "#${colorscheme.dark.bg_0}";
            foreground = "#${colorscheme.dark.fg_0}";
            dim_foreground = "#${colorscheme.dark.dim_0}";
          };

          colors.normal = {
            black = "#636363";
            red = "#${colorscheme.dark.red}";
            green = "#${colorscheme.dark.green}";
            yellow = "#${colorscheme.dark.yellow}";
            blue = "#${colorscheme.dark.blue}";
            magenta = "#${colorscheme.dark.magenta}";
            cyan = "#${colorscheme.dark.cyan}";
            white = "#f7f7f7";
          };

          colors.bright = {
            black = "#636363";
            red = "#${colorscheme.dark.br_red}";
            green = "#${colorscheme.dark.br_green}";
            yellow = "#${colorscheme.dark.br_yellow}";
            blue = "#${colorscheme.dark.br_blue}";
            magenta = "#${colorscheme.dark.br_magenta}";
            cyan = "#${colorscheme.dark.br_cyan}";
            white = "#f7f7f7";
          };
        };
      };

      services.polybar = {
        enable = true;
        config = ./polybar/config.ini;
        script = "polybar mainBar &";
      };

      xsession = {
        enable = true;

        initExtra = extra + hdmiExtra;

        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hp: [
            hp.dbus
            hp.monad-logger
          ];
          config = pkgs.writeText "xmonad.hs" ''
            import           Control.Monad                         ( replicateM_ )
            import           Data.Foldable                         ( traverse_ )
            import           Data.Monoid
            import           Graphics.X11.ExtraTypes.XF86
            import           System.Exit
            import           System.IO                             ( hPutStr
                                                                   , hClose
                                                                   )
            import           XMonad
            import           XMonad.Actions.CycleWS                ( Direction1D(..)
                                                                   , WSType(..)
                                                                   , findWorkspace
                                                                   )
            import           XMonad.Actions.DynamicProjects        ( Project(..)
                                                                   , dynamicProjects
                                                                   , switchProjectPrompt
                                                                   )
            import           XMonad.Actions.DynamicWorkspaces      ( removeWorkspace )
            import           XMonad.Actions.FloatKeys              ( keysAbsResizeWindow
                                                                   , keysResizeWindow
                                                                   )
            import           XMonad.Actions.RotSlaves              ( rotSlavesUp )
            import           XMonad.Actions.SpawnOn                ( manageSpawn
                                                                   , spawnOn
                                                                   )
            import           XMonad.Actions.WithAll                ( killAll )
            import           XMonad.Hooks.EwmhDesktops             ( ewmh
                                                                   , ewmhDesktopsEventHook
                                                                   , fullscreenEventHook
                                                                   )
            import           XMonad.Hooks.FadeInactive             ( fadeInactiveLogHook )
            import           XMonad.Hooks.InsertPosition           ( Focus(Newer)
                                                                   , Position(Below)
                                                                   , insertPosition
                                                                   )
            import           XMonad.Hooks.ManageDocks              ( Direction2D(..)
                                                                   , ToggleStruts(..)
                                                                   , avoidStruts
                                                                   , docks
                                                                   , docksEventHook
                                                                   )
            import           XMonad.Hooks.ManageHelpers            ( (-?>)
                                                                   , composeOne
                                                                   , doCenterFloat
                                                                   , doFullFloat
                                                                   , isDialog
                                                                   , isFullscreen
                                                                   , isInProperty
                                                                   )
            import           XMonad.Hooks.UrgencyHook              ( UrgencyHook(..)
                                                                   , withUrgencyHook
                                                                   )
            import           XMonad.Layout.Gaps                    ( gaps )
            import           XMonad.Layout.MultiToggle             ( Toggle(..)
                                                                   , mkToggle
                                                                   , single
                                                                   )
            import           XMonad.Layout.MultiToggle.Instances   ( StdTransformers(NBFULL) )
            import           XMonad.Layout.NoBorders               ( smartBorders )
            import           XMonad.Layout.PerWorkspace            ( onWorkspace )
            import           XMonad.Layout.Spacing                 ( spacing )
            import           XMonad.Layout.ThreeColumns            ( ThreeCol(..) )
            import           XMonad.Util.EZConfig                  ( mkNamedKeymap )
            import           XMonad.Util.NamedActions              ( (^++^)
                                                                   , NamedAction (..)
                                                                   , addDescrKeys'
                                                                   , addName
                                                                   , showKm
                                                                   , subtitle
                                                                   )
            import           XMonad.Util.NamedScratchpad           ( NamedScratchpad(..)
                                                                   , customFloating
                                                                   , defaultFloating
                                                                   , namedScratchpadAction
                                                                   , namedScratchpadManageHook
                                                                   )
            import           XMonad.Util.SpawnOnce                 ( spawnOnce )
            import           XMonad.Util.WorkspaceCompare          ( getSortByIndex )

            import qualified Control.Exception                     as E
            import qualified Data.Map                              as M
            import qualified XMonad.StackSet                       as W
            import qualified XMonad.Util.NamedWindows              as W
            import XMonad.Hooks.DynamicLog
            import XMonad.Util.Run
            import XMonad.Prompt
            import XMonad.Prompt.Input
            import XMonad.Layout.IndependentScreens
            import Data.Char (isSpace)

            main :: IO ()
            main = do
              spawn "feh --bg-fill ${wallpaper}"

            startUp xm = xmonad . docks . ewmh . dynProjects . urgencyHook $ def
              { terminal           = myTerminal
              , focusFollowsMouse  = True
              , clickJustFocuses   = False
              , borderWidth        = 2
              , modMask            = mod4Mask
              , keys = keybindings
              , workspaces         = withScreens 2 myWS
              , normalBorderColor  = "#BFBFBF"
              , focusedBorderColor = "#bd93f9"
              , mouseBindings      = myMouseBindings
              , layoutHook         = myLayout
              , manageHook         = myManageHook
              , handleEventHook    = myEventHook
              , startupHook        = myStartupHook
              , logHook            = dynamicLogWithPP xmobarPP
                                     {
                                       ppOutput = hPutStrLn xm
                                     }
              }
             where
              dynProjects = dynamicProjects projects
              urgencyHook = withUrgencyHook LibNotifyUrgencyHook

            myStartupHook = startupHook def

            data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

            instance UrgencyHook LibNotifyUrgencyHook where
              urgencyHook LibNotifyUrgencyHook w = do
                name     <- W.getName w
                maybeIdx <- W.findTag w <$> gets windowset
                traverse_ (\i -> safeSpawn "notify-send" [show name, "workspace " ++ i]) maybeIdx

            ------------------------------------------------------------------------
            -- Key bindings. Add, modify or remove key bindings here.
            --

            myTerminal   = "urxvt"
            fileManager  = "urxvt -e ranger"
            appLauncher  = "dmenu_run"
            screenLocker = "multilockscreen -l dim"
            playerctl c  = "playerctl --player=spotify,%any " <> c

            keybindings conf@XConfig {XMonad.modMask = modm} = M.fromList $
                [ ((0, xF86XK_AudioMute              ), spawn "amixer -q set Master toggle")
                , ((0, xF86XK_AudioLowerVolume       ), spawn "amixer -q set Master 5%-")
                , ((0, xF86XK_AudioRaiseVolume       ), spawn "amixer -q set Master 5%+")
                , ((0, xF86XK_AudioPlay              ), spawn $ playerctl "play-pause")
                , ((0, xF86XK_AudioStop              ), spawn $ playerctl "stop")
                , ((0, xF86XK_AudioPrev              ), spawn $ playerctl "previous")
                , ((0, xF86XK_AudioNext              ), spawn $ playerctl "next")
                , ((modm .|. shiftMask  , xK_Return  ), spawn (XMonad.terminal conf))
                , ((modm                , xK_p       ), spawn appLauncher)
                , ((modm                , xK_x       ), runNixpkg def "Run")
                , ((modm .|. shiftMask  , xK_d       ), spawn fileManager)
                , ((modm                , xK_space   ), sendMessage NextLayout)
                , ((modm .|. shiftMask  , xK_space   ), setLayout (XMonad.layoutHook conf))
                , ((modm                , xK_f       ), sendMessage (Toggle NBFULL))
                , ((modm                , xK_o       ), switchProjectPrompt projectsTheme)
                , ((modm .|. shiftMask  , xK_q       ), io exitSuccess)
                , ((modm .|. shiftMask  , xK_c       ), kill)
                , ((modm                , xK_c       ), killAll)
                , ((modm                , xK_n       ), refresh)
                , ((modm                , xK_j       ), windows W.focusDown)
                , ((modm                , xK_k       ), windows W.focusUp)
                , ((modm                , xK_m       ), windows W.focusMaster)
                , ((modm                , xK_Return  ), windows W.swapMaster)
                , ((modm .|. shiftMask  , xK_j       ), windows W.swapDown)
                , ((modm .|. shiftMask  , xK_k       ), windows W.swapUp)
                , ((modm                , xK_h       ), sendMessage Shrink)
                , ((modm                , xK_l       ), sendMessage Expand)
                , ((modm                , xK_t       ), withFocused (windows . W.sink))
                , ((modm .|. shiftMask  , xK_Tab     ), rotSlavesUp)
                , ((modm                , xK_period  ), nextWS')
                , ((modm                , xK_comma   ), prevWS')
                , ((modm .|. shiftMask  , xK_F4      ), removeWorkspace)
                , ((modm .|. controlMask, xK_s       ), runScratchpadApp spotify)
                , ((modm .|. controlMask, xK_e       ), spawn "emacs")
                , ((modm .|. controlMask, xK_f       ), spawn "firefox")
                , ((modm .|. controlMask, xK_p       ), runScratchpadApp pavuctrl)
                ] ++ switchWsById
             where
              switchWsById =
                [ ((m .|. modm, k), (windows $ onCurrentScreen f i)) | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9], (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

              switchScreen =
                [ ((m .|. modm, k), (screenWorkspace sc >>= flip whenJust (windows . f))) | (k, sc) <- zip [xK_w, xK_e, xK_r] [0..], (f, m)  <- [(W.view, 0), (W.shift, shiftMask)]]

            ----------- Cycle through workspaces one by one but filtering out NSP (scratchpads) -----------

            nextWS' = switchWS Next
            prevWS' = switchWS Prev

            switchWS dir =
              findWorkspace filterOutNSP dir AnyWS 1 >>= windows . W.view

            filterOutNSP =
              let g f xs = filter (\(W.Workspace t _ _) -> t /= "NSP") (f xs)
              in  g <$> getSortByIndex

            ------------------------------------------------------------------------
            -- Mouse bindings: default actions bound to mouse events
            --
            myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList
                [ ((modm, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
                , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
                , ((modm, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
                ]

            myLayout =
              avoidStruts
                . smartBorders
                . fullScreenToggle
                . sysLayout
                . cliLayout
                . msgLayout
                . devLayout
                . webLayout$ (tiled ||| Mirror tiled ||| column3 ||| full)
               where
                 -- default tiling algorithm partitions the screen into two panes
                 tiled   = gapSpaced 10 $ Tall nmaster delta ratio
                 full    = gapSpaced 5 Full
                 column3 = gapSpaced 10 $ ThreeColMid 1 (3/100) (1/2)

                 -- The default number of windows in the master pane
                 nmaster = 1

                 -- Default proportion of screen occupied by master pane
                 ratio   = 1/2

                 -- Percent of screen to increment by when resizing panes
                 delta   = 3/100

                 -- Gaps bewteen windows
                 myGaps gap  = gaps [(U, gap),(D, gap),(L, gap),(R, gap)]
                 gapSpaced g = spacing g . myGaps g

                 -- Per workspace layout
                 sysLayout = onWorkspace sysWs (tiled ||| full)
                 devLayout = onWorkspace devWs (tiled ||| full)
                 webLayout = onWorkspace webWs (tiled ||| full)
                 cliLayout = onWorkspace cliWs (tiled ||| full)
                 msgLayout = onWorkspace msgWs (tiled ||| full)

                 -- Fullscreen
                 fullScreenToggle = mkToggle (single NBFULL)

            ------------------------------------------------------------------------
            -- Window rules:

            -- Execute arbitrary actions and WindowSet manipulations when managing
            -- a new window. You can use this to, for example, always float a
            -- particular program, or have a client always appear on a particular
            -- workspace.
            --
            -- To find the property name associated with a program, use
            -- > xprop | grep WM_CLASS
            -- and click on the client you're interested in.
            --
            -- To match on the WM_NAME, you can use 'title' in the same way that
            -- 'className' and 'resource' are used below.
            --

            type AppName      = String
            type AppTitle     = String
            type AppClassName = String
            type AppCommand   = String

            data App
              = ClassApp AppClassName AppCommand
              | TitleApp AppTitle AppCommand
              | NameApp AppName AppCommand
              deriving Show

            gimp      = ClassApp "Gimp"                 "gimp"
            pavuctrl  = ClassApp "Pavucontrol"          "pavucontrol"
            spotify   = ClassApp "Spotify"              "spotify"

            myManageHook = manageApps <+> manageSpawn <+> manageScratchpads
             where
              isBrowserDialog     = isDialog <&&> className =? "Firefox"
              isFileChooserDialog = isRole =? "GtkFileChooserDialog"
              isPopup             = isRole =? "pop-up"
              isSplash            = isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_SPLASH"
              isRole              = stringProperty "WM_WINDOW_ROLE"
              tileBelow           = insertPosition Below Newer
              doCalendarFloat   = customFloating (W.RationalRect (11 / 15) (1 / 48) (1 / 4) (1 / 4))
              manageScratchpads = namedScratchpadManageHook scratchpads
              anyOf :: [Query Bool] -> Query Bool
              anyOf = foldl (<||>) (pure False)
              match :: [App] -> Query Bool
              match = anyOf . fmap isInstance
              manageApps = composeOne
                [ match [ gimp ]                   -?> doFloat
                , match [ spotify ] -?> doFullFloat
                , resource =? "desktop_window"             -?> doIgnore
                , resource =? "kdesktop"                   -?> doIgnore
                , anyOf [ isBrowserDialog
                        , isFileChooserDialog
                        , isDialog
                        , isPopup
                        , isSplash
                        ]                                  -?> doCenterFloat
                , isFullscreen                             -?> doFullFloat
                , pure True                                -?> tileBelow
                ]

            isInstance (ClassApp c _) = className =? c
            isInstance (TitleApp t _) = title =? t
            isInstance (NameApp n _)  = appName =? n

            getNameCommand (ClassApp n c) = (n, c)
            getNameCommand (TitleApp n c) = (n, c)
            getNameCommand (NameApp  n c) = (n, c)

            getAppName    = fst . getNameCommand
            getAppCommand = snd . getNameCommand

            scratchpadApp :: App -> NamedScratchpad
            scratchpadApp app = NS (getAppName app) (getAppCommand app) (isInstance app) defaultFloating

            runScratchpadApp = namedScratchpadAction scratchpads . getAppName

            scratchpads = scratchpadApp <$> [ spotify, pavuctrl, gimp ]

            ------------------------------------------------------------------------
            -- Workspaces
            --
            webWs = "web"
            devWs = "dev"
            cliWs = "cli"
            msgWs = "msg"
            sysWs = "sys"

            myWS :: [WorkspaceId]
            myWS = [webWs, devWs, cliWs, msgWs, sysWs]

            projects :: [Project]
            projects =
              [ Project { projectName      = webWs
                        , projectDirectory = "~/"
                        , projectStartHook = Nothing
                        }
              , Project { projectName      = devWs
                        , projectDirectory = "~/Devel"
                        , projectStartHook = Nothing
                        }
              , Project { projectName      = cliWs
                        , projectDirectory = "~/"
                        , projectStartHook = Nothing
                        }
              , Project { projectName      = msgWs
                        , projectDirectory = "~/"
                        , projectStartHook = Nothing
                        }
              , Project { projectName      = sysWs
                        , projectDirectory = "/home/florian/nixos/"
                        , projectStartHook = Just . spawn $ myTerminal <> " -e sudo su"
                        }
              ]

            projectsTheme :: XPConfig
            projectsTheme = amberXPConfig
              { bgHLight = "#002b36"
              , font     = "xft:Bitstream Vera Sans Mono:size=8:antialias=true"
              , height   = 50
              , position = CenteredAt 0.5 0.5
              }

            myEventHook = docksEventHook <+> ewmhDesktopsEventHook <+> fullscreenEventHook

            myLogHook = fadeInactiveLogHook 0.9

            runNixpkg :: XPConfig -> String -> X ()
            runNixpkg conf x = inputPrompt conf x ?+ \i -> spawn $ "nix-shell -p " ++ i ++ " --run " ++ i
          '';
        };
      };
    };
}
