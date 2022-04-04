import XMonad
import XMonad.Config.Xfce
import System.Exit
import qualified XMonad.StackSet as W
import Data.Monoid
import qualified Data.Map        as M
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Hooks.ManageDocks

--Layouts & Layout Modifiers
import XMonad.Layout.Spiral
import XMonad.Layout.GridVariants(Grid(Grid))
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.MultiToggle

-------------
--VARIABLES
-------------
myModMask            :: KeyMask
myModMask            = mod4Mask 

myTerminal           :: String
myTerminal           = "xfce4-terminal"

myBorderWidth        :: Dimension
myBorderWidth        = 2

myNormalBorderColor  = "#828282"
myFocusedBorderColor  = "#f7f7f7"

--True spacing will be twice this number
myWindowSpacing      :: Integer
myWindowSpacing      = 5 

--Adds spacing to all layouts based on myWindowSpacing
myLayoutSpacing      = spacingRaw 
                     True
                     (Border myWindowSpacing myWindowSpacing myWindowSpacing myWindowSpacing) 
                     True
                     (Border myWindowSpacing myWindowSpacing myWindowSpacing myWindowSpacing) 
                     True

-------------
--KEYBINDINGS
-------------
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
-------------------------------------------------------------------------------
--MAIN
-------------------------------------------------------------------------------
main = xmonad xfceConfig
            { modMask = myModMask 
            , terminal =myTerminal
            , borderWidth=myBorderWidth
            , normalBorderColor=myNormalBorderColor
            , focusedBorderColor=myFocusedBorderColor
            , keys = myKeys
            , mouseBindings=myMouseBindings
            , layoutHook = myLayout}
