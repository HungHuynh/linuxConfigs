/* See LICENSE file for copyright and license details. */

/* Include */
// #include "X11/F86kysym.h"

/* appearance */
static const char font[]   = "-*-monaco-*-*-*-14-*-*-*-*-*-*-*-*";

#define NUMCOLORS 8

static const char colors[NUMCOLORS][ColLast][8] = {
    // border foreground background
    { "#212121", "#696969", "#121212" }, // 0 = normal
    { "#696969", "#E0E0E0", "#121212" }, // 1 = selected
    { "#212121", "#CF4F88", "#121212" }, // 2 = red
    { "#212121", "#53A6A6", "#121212" }, // 3 = green
    { "#212121", "#914E89", "#121212" }, // 4 = yellow
    { "#212121", "#47959E", "#121212" }, // 5 = cyan
    { "#212121", "#7E62B3", "#121212" }, // 6 = magenta
    { "#212121", "#C0C0C0", "#121212" }, // 7 = white
};

static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = False;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "term", "browser", "relax", "read"};

static const Rule rules[] = {
    /* class                instance        title           tags mask     isfloating   monitor */
    { "Gimp",               NULL,           NULL,           0,            True,        -1 },
    { "chromium-browser",   NULL,           NULL,           1 << 2,       False,       -1 },
    { "Mplayer",            NULL,           NULL,           1 << 3,       True,        -1 },
    {  NULL,                NULL,           "scratchpad",   0,            True,        -1 },

};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[T]",      tile },    /* first entry is default */
    { "[F]",      NULL },    /* no layout function means floating behavior */
    { "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[]      = { "dmenu_run", "-fn", font, "-nb", colors[0][ColBG], "-nf", colors[0][ColFG], "-sb", colors[1][ColBG], "-sf", colors[1][ColFG], NULL };
static const char *termcmd[]        = { "urxvtc", NULL };
static const char *padcmd[]         = { "urxvtc", "-title", "scratchpad", "-geometry", "54x10+504+12", NULL };
static const char *soundMute[]      = { "amixer", "set", "Master", "toggle", NULL };
static const char *soundUp[]        = { "amixer", "set", "Master", "2+", NULL };
static const char *soundDown[]      = { "amixer", "set", "Master", "2-", NULL };
static const char *soundNext[]      = { "ncmpcpp", "next", NULL };
static const char *soundPrev[]      = { "ncmpcpp", "next", NULL };


static Key keys[] = {
    /* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ 0,                     		Mod4Mask,         spawn,          {.v = dmenucmd } },
    { Mod4Mask,                     XK_Return, spawn,          {.v = termcmd } },
    { Mod4Mask,                     XK_p,      spawn,          {.v = padcmd } },
    /* my own binding start */
    { Mod4Mask,                     XK_b,      spawn,          SHCMD("exec chromium-browser") },
    {      0,                       XK_Print,  spawn,          SHCMD("exec scrot -q 100 -t 25 '%Y-%m-%d-%H-%M-%S.jpg' -e 'mv $f $m /mnt/ntfs-tmp/tmp/screenshots'") },
    {      0,                       0x1008ff12,spawn,          {.v = soundMute } },
    { MODKEY,                       XK_Left	  ,spawn,          {.v = soundMute } },
    {      0,                       0x1008ff11,spawn,          {.v = soundDown } },
    { MODKEY,                       XK_Down	  ,spawn,          {.v = soundDown } },
    {      0,                       0x1008ff13,spawn,          {.v = soundUp } },
    { MODKEY,                       XK_Up	  ,spawn,          {.v = soundUp } },
    {      0,                       0x1008ff16,spawn,          {.v = soundPrev } },
    {      0,                       0x1008ff17,spawn,          {.v = soundNext } },
    /* my own binding end   */
    { MODKEY,                       XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
    { MODKEY,                       XK_Return, zoom,           {0} },
    { MODKEY,                       XK_Tab,    view,           {0} },
    { MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
    { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
    { MODKEY,                       XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0)
        TAGKEYS(                        XK_2,                      1)
        TAGKEYS(                        XK_3,                      2)
        TAGKEYS(                        XK_4,                      3)
        TAGKEYS(                        XK_5,                      4)
        TAGKEYS(                        XK_6,                      5)
        TAGKEYS(                        XK_7,                      6)
        TAGKEYS(                        XK_8,                      7)
        TAGKEYS(                        XK_9,                      8)
        { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

