------------------------------------------------------------------------
--IMPORTS
------------------------------------------------------------------------

  --Base
import XMonad
import System.Exit
import qualified XMonad.StackSet as W

  --Data
import Data.Monoid
import qualified Data.Map        as M

  --Util
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

  --Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog

  --Layouts & Layout Modifiers
import XMonad.Layout.Spiral
import XMonad.Layout.GridVariants(Grid(Grid))
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.MultiToggle


  --Prompts
import XMonad.Prompt
import XMonad.Prompt.XMonad
import XMonad.Prompt.Man
import XMonad.Prompt.FuzzyMatch
  --Actions


------------------------------------------------------------------------
--VARIABLES
------------------------------------------------------------------------
myTerminal           :: String
myTerminal           = "alacritty"

myFocusFollowsMouse  :: Bool
myFocusFollowsMouse  = True

myClickJustFocuses   :: Bool
myClickJustFocuses   = False

myBorderWidth        :: Dimension
myBorderWidth        = 2

--True spacing will be twice this number
myWindowSpacing      :: Integer
myWindowSpacing      = 5 

myModMask            :: KeyMask
myModMask            = mod4Mask 

myWorkspaces         = ["1","2","3","4","5","6","7","8","9"]

myNormalBorderColor  = "#828282"
myFocusedBorderColor  = "#f7f7f7"

--Adds spacing to all layouts based on myWindowSpacing
myLayoutSpacing      = spacingRaw 
                     True
                     (Border myWindowSpacing myWindowSpacing myWindowSpacing myWindowSpacing) 
                     True
                     (Border myWindowSpacing myWindowSpacing myWindowSpacing myWindowSpacing) 
                     True  
------------------------------------------------------------------------
--KEY BINDINGS
------------------------------------------------------------------------
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_r     ), spawn "dmenu_run")

    -- launch gmrun
    --,((modm,               xK_r     ), spawn "gmrun")

    -- Close focused window
    , ((modm,               xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm .|. shiftMask, xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_d     ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_space ), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm,               xK_period), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm,               xK_comma), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{x,c,v}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{x,c,v}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_x, xK_c, xK_v] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
--MOUSE BINDINGS
------------------------------------------------------------------------

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
--LAYOUTS
------------------------------------------------------------------------
--
--Layouts given here
--Modifiers are outside the parentheses and chained with $
--Layouts are inside the parentheses and connected with |||
--
myLayout = avoidStruts $ myLayoutSpacing $ (tiled ||| Mirror tiled ||| Full)
    where tiled = Tall 1 (3/100) (1/2)
------------------------------------------------------------------------
-- WINDOW RULES
-----------------------------------------------------------------------
--
--Set properties for certain windows, like making them floating by default
--
myManageHook = composeAll
    [ className =? "Krita"        --> doFloat
    , className =? "Gimp"         --> doFloat
    , className =? "Blender"      --> doFloat]

------------------------------------------------------------------------
-- EVENT HANDLING
------------------------------------------------------------------------A
--
-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
--STATUS BARS & LOGGING
------------------------------------------------------------------------
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
--STARTUP HOOK
------------------------------------------------------------------------
--
--Perform an arbitrary action each time xmonad starts. Does not run on
--restart, you must fully quit and start Xmonad
--
myStartupHook = do
        spawnOnce "lxsession &"
        --Monitor dependent, needs to be changed based on your setup
        spawnOnce "xrandr --output HDMI-1-0 --mode 1920x1080"
        spawnOnce "xwallpaper --zoom ~/.config/wall.png &"
        spawnOnce "picom --experimental-backends --backend glx --xrender-sync-fence" 

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmproc<-spawnPipe "xmobar -x 0 /home/mb/.config/xmobarrc"
  xmonad $ docks defaults 

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
