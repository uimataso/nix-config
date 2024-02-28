/* See LICENSE file for copyright and license details. */

#define SESSION_FILE "/tmp/dwm-session"
#define STATUSBAR    "dwmblocks"

/* appearance */
static unsigned int borderpx  = 1;        /* border pixel of windows */
static unsigned int snap      = 32;       /* snap pixel */
static unsigned int gappx     = 5;        /* gaps between windows */
static int showbar            = 1;        /* 0 means no bar */
static int topbar             = 1;        /* 0 means bottom bar */
static char font[]            = "MesloLGS Nerd Font:size=9";
static char font2[]           = "Noto Sans CJK TC:size=9.5";
static const char *fonts[]    = { font, font2, "monospace:size=10" };
static char bgcolor[]         = "#222222";
static char fgcolor[]         = "#eeeeee";
static char bgaltcolor[]      = "#444444";
static char fgaltcolor[]      = "#888888";
static char primary[]         = "#005577";
static char *colors[][3] = {
        /*                  fg          bg         border   */
	[SchemeNorm]    = { fgcolor,    bgcolor,   bgaltcolor },
	[SchemeSel]     = { bgcolor,    primary,   primary },
	[SchemeEmt]     = { fgaltcolor, bgcolor,   bgcolor },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class       instance    title           tags mask   isfloating  monitor     scratch key */
	{ NULL,        NULL,       "osu!",         1 << 5,     0,          -1,         0  },
	{ "discord",   NULL,       NULL,           1 << 6,     0,          -1,         0  },

	{ "float",     NULL,       NULL,           0,          1,          -1,         0  },
	{ NULL,        NULL,       "fmenu",        0,          1,          -1,         0  },
	{ NULL,        "qrcode",   NULL,           0,          1,          -1,         0  },

	{ "Emacs",     NULL,       NULL,           0,          0,          -1,        'n' },
	{ NULL,        NULL,       "packages",     0,          1,          -1,        'p' },
	{ NULL,        NULL,       "scratchpad",   0,          1,          -1,        's' },
};

/* layout(s) */
static float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static int nmaster     = 1;    /* number of clients in master area */
static int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
};

/*
 * Xresources preferences to load at startup
 */
ResourcePref resources[] = {
	{ "background",         STRING,  &bgcolor },
	{ "foreground",         STRING,  &fgcolor },
	{ "bgaltcolor",         STRING,  &bgaltcolor },
	{ "fgaltcolor",         STRING,  &fgaltcolor },
	{ "primary",            STRING,  &primary },
	{ "borderpx",           INTEGER, &borderpx },
	{ "gappx",              INTEGER, &gappx },
	{ "snap",               INTEGER, &snap },
	{ "showbar",            INTEGER, &showbar },
	{ "topbar",             INTEGER, &topbar },
	{ "mfact",              FLOAT,   &mfact },
	{ "nmaster",            INTEGER, &nmaster },
	{ "resizehints",        INTEGER, &resizehints },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* XF86 key support */
#include <X11/XF86keysym.h>

#define _____      spawn, { .v = (const char*[]){ NULL } }
#define SPAWN(...) { .v = (const char*[]){ __VA_ARGS__, NULL } }
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define TERM(cmd)  { .v = (const char*[]){ "/bin/sh", "-c", "${TERMINAL:-st} " cmd, NULL } }

#define SCRATCH_NOTE "/bin/sh", "-c", "emacsclient -c"
#define SCRATCH_PKG  "/bin/sh", "-c", "${TERMINAL:-st} -g 100x35 -t packages $EDITOR ${XDG_BOOKMARK_DIR:-$HOME/bm}/pkg-$(cat /etc/hostname)"

static Key keys[] = {
	/* modifier             key                 function        argument */
	{ MODKEY,               XK_grave,           _____ },
	{ MODKEY|ShiftMask,     XK_grave,           _____ },
	TAGKEYS(                XK_1,                               0)
	TAGKEYS(                XK_2,                               1)
	TAGKEYS(                XK_3,                               2)
	TAGKEYS(                XK_4,                               3)
	TAGKEYS(                XK_5,                               4)
	TAGKEYS(                XK_6,                               5)
	TAGKEYS(                XK_7,                               6)
	TAGKEYS(                XK_8,                               7)
	TAGKEYS(                XK_9,                               8)
	{ MODKEY,               XK_0,               view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,     XK_0,               tag,            {.ui = ~0 } },
	{ MODKEY,               XK_minus,           spawn,          SHCMD("vl down 5") },
	{ MODKEY|ShiftMask,     XK_minus,           spawn,          SHCMD("vl sink-mute") },
	{ MODKEY,               XK_equal,           spawn,          SHCMD("vl switch") },
	{ MODKEY|ShiftMask,     XK_equal,           spawn,          SHCMD("vl up 5") },

	{ MODKEY,               XK_Escape,          spawn,          SHCMD("power-menu") },
	{ MODKEY|ShiftMask,     XK_Escape,          _____ },
	{ MODKEY,               XK_BackSpace,       view,           {0} },
	{ MODKEY|ShiftMask,     XK_BackSpace,       _____ },
	{ MODKEY,               XK_Tab,             shiftviewclients, { .i = +1 } },
	{ MODKEY|ShiftMask,     XK_Tab,             shiftviewclients, { .i = -1 } },
	{ MODKEY,               XK_Return,          spawn,          SHCMD("$TERMINAL") },
	{ MODKEY|ShiftMask,     XK_Return,          _____ },
	{ MODKEY,               XK_space,           zoom,           {0} },
	{ MODKEY|ShiftMask,     XK_space,           _____ },

	{ MODKEY,               XK_q,               killclient,     {0} },
	{ MODKEY|ShiftMask,     XK_q,               quit,           {1} },
	TAGKEYS(                XK_w,                               6)
	TAGKEYS(                XK_e,                               7)
	TAGKEYS(                XK_r,                               8)
	{ MODKEY,               XK_t,               spawn,          TERM("-t trans -c float tl sele") },
	{ MODKEY|ShiftMask,     XK_t,               spawn,          TERM("-t trans -c float tl editor") },
	{ MODKEY,               XK_y,               spawn,          SHCMD("open-in-mpv") },
	{ MODKEY|ShiftMask,     XK_y,               _____ },
	{ MODKEY,               XK_u,               spawn,          SHCMD("ibus-script next") },
	{ MODKEY|ShiftMask,     XK_u,               _____ },
	{ MODKEY,               XK_i,               spawn,          SPAWN("quicktype") },
	{ MODKEY|ShiftMask,     XK_i,               _____ },
	{ MODKEY,               XK_o,               spawn,          SPAWN("app-launcher") },
	{ MODKEY|ShiftMask,     XK_o,               _____ },
	{ MODKEY,               XK_p,               togglescratch,  SPAWN("p", SCRATCH_PKG) },
	{ MODKEY|ShiftMask,     XK_p,               spawn,          TERM("-t upgrad sb-popupgrade") },
	{ MODKEY,               XK_bracketleft,     _____ },
	{ MODKEY|ShiftMask,     XK_bracketleft,     _____ },
	{ MODKEY,               XK_bracketright,    _____ },
	{ MODKEY|ShiftMask,     XK_bracketright,    _____ },
	{ MODKEY,               XK_backslash,       _____ },
	{ MODKEY|ShiftMask,     XK_backslash,       _____ },


	{ MODKEY,               XK_a,               view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,     XK_a,               tag,            {.ui = ~0 } },
	TAGKEYS(                XK_s,                               3)
	TAGKEYS(                XK_d,                               4)
	TAGKEYS(                XK_f,                               5)
	// { MODKEY,               XK_f,               togglefullscr,  {0} },
	// { MODKEY|ShiftMask,     XK_f,               togglefloating, {0} },
	{ MODKEY,               XK_g,               togglefullscr,  {0} },
	{ MODKEY|ShiftMask,     XK_g,               togglefloating, {0} },
	{ MODKEY,               XK_h,               setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,     XK_h,               incnmaster,     {.i = +1 } },
	{ MODKEY,               XK_j,               focusstack,     {.i = INC(+1) } },
	{ MODKEY|ShiftMask,     XK_j,               pushstack,      {.i = INC(+1) } },
	{ MODKEY,               XK_k,               focusstack,     {.i = INC(-1) } },
	{ MODKEY|ShiftMask,     XK_k,               pushstack,      {.i = INC(-1) } },
	{ MODKEY,               XK_l,               setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,     XK_l,               incnmaster,     {.i = -1 } },
	{ MODKEY,               XK_semicolon,       spawn,          SPAWN("app-launcher") },
	{ MODKEY|ShiftMask,     XK_semicolon,       _____ },
	{ MODKEY,               XK_apostrophe,      _____ },
	{ MODKEY|ShiftMask,     XK_apostrophe,      _____ },


	{ MODKEY,               XK_z,               togglebar,      {0} },
	{ MODKEY|ShiftMask,     XK_z,               _____ },
	TAGKEYS(                XK_x,                               0)
	TAGKEYS(                XK_c,                               1)
	TAGKEYS(                XK_v,                               2)
	{ MODKEY,               XK_b,               spawn,          SHCMD("$BROWSER") },
	{ MODKEY|ShiftMask,     XK_b,               spawn,          TERM("-c float -e ${EDITOR-:vim} ${XDG_BOOKMARK_DIR:-$HOME/bm}/bookmark") },
	{ MODKEY,               XK_n,               togglescratch,  SPAWN("n", SCRATCH_NOTE) },
	{ MODKEY|ShiftMask,     XK_n,               _____ },
	{ MODKEY,               XK_m,               focusstack,     {.i = 0 } },
	{ MODKEY|ShiftMask,     XK_m,               pushstack,      {.i = 0 } },
	{ MODKEY,               XK_comma,           focusmon,       {.i = -1 } },
	{ MODKEY|ShiftMask,     XK_comma,           tagmon,         {.i = -1 } },
	{ MODKEY,               XK_period,          focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,     XK_period,          tagmon,         {.i = +1 } },
	{ MODKEY,               XK_slash,           _____ },
	{ MODKEY|ShiftMask,     XK_slash,           _____ },

	{ MODKEY,               XK_Left,            setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,     XK_Left,            _____ },
	{ MODKEY,               XK_Up,              focusstack,     {.i = INC(-1) } },
	{ MODKEY|ShiftMask,     XK_Up,              pushstack,      {.i = INC(-1) } },
	{ MODKEY,               XK_Down,            focusstack,     {.i = INC(+1) } },
	{ MODKEY|ShiftMask,     XK_Down,            pushstack,      {.i = INC(+1) } },
	{ MODKEY,               XK_Right,           setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,     XK_Right,           _____ },

	{ MODKEY,               XK_Insert,          _____ },
	{ MODKEY|ShiftMask,     XK_Insert,          _____ },
	{ MODKEY,               XK_Delete,          _____ },
	{ MODKEY|ShiftMask,     XK_Delete,          _____ },
	{ MODKEY,               XK_Home,            _____ },
	{ MODKEY|ShiftMask,     XK_Home,            _____ },
	{ MODKEY,               XK_End,             _____ },
	{ MODKEY|ShiftMask,     XK_End,             _____ },
	{ MODKEY,               XK_Page_Up,         _____ },
	{ MODKEY|ShiftMask,     XK_Page_Up,         _____ },
	{ MODKEY,               XK_Page_Down,       _____ },
	{ MODKEY|ShiftMask,     XK_Page_Down,       _____ },

	{ 0,                    XK_Print,           spawn,          SPAWN("screenshot", "sel") },
	{ ShiftMask,            XK_Print,           spawn,          SPAWN("screenshot", "full") },
	{ ControlMask,          XK_Print,           spawn,          SPAWN("screenshot", "cur") },
	{ ShiftMask|ControlMask,XK_Print,           spawn,          SPAWN("colorpicker") },
	{ 0,                    XK_Scroll_Lock,     _____ },
	{ 0,                    XK_Pause,           _____ },

	{ MODKEY,               XK_F5,              xrdb,           {.v = NULL } },
	{ MODKEY,               XK_F6,              spawn,          SHCMD("kill -10 $(pidof dwmblocks)") },

	{ 0,            XF86XK_AudioRaiseVolume,    spawn,          SHCMD("vl up 5") },
	{ 0,            XF86XK_AudioLowerVolume,    spawn,          SHCMD("vl down 5") },
	{ 0,            XF86XK_AudioMute,           spawn,          SHCMD("vl sink-mute") },
	{ 0,            XF86XK_AudioMicMute,        spawn,          SHCMD("vl source-mute") },
	{ 0,            XF86XK_MonBrightnessUp,     spawn,          SHCMD("bright up") },
	{ 0,            XF86XK_MonBrightnessDown,   spawn,          SHCMD("bright down") },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },
	{ ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },
	{ ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },
	{ ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },
	{ ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },
	{ ClkStatusText,        ShiftMask,      Button2,        sigstatusbar,   {.i = 6} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	// { ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },

	{ ClkClientWin,         MODKEY,         Button4,        spawn,          SPAWN("vl", "up", "5") },
	{ ClkClientWin,         MODKEY,         Button5,        spawn,          SPAWN("vl", "down", "5") },
	{ ClkClientWin,         0,              10,             spawn,          SPAWN("vl", "up", "5") },
	{ ClkClientWin,         0,              11,             spawn,          SPAWN("vl", "down", "5") },
};
